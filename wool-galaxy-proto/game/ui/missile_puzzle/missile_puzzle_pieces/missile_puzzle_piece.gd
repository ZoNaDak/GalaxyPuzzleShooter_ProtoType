# missile_puzzle_piece.gd
extends Control

class_name MissilePuzzlePiece

enum MoveState {
	IDLE,
	SETUP_FOR_MOVE,
	WAIT_MOVE,
	MOVE_FOR_EQUIP,
	BUMPED,
	RETURN_TO_ORIGIN,
	WAIT_EXIT,
	EXITED_BOARD,
}

#region Consts

const MISSILE_CONFIG: MissileConfig = preload("res://config/resources/missile_config.tres")

const SMALL_SIZE := Vector2(32, 16)
const MEDIUM_SIZE := Vector2(48, 16)
const LARGE_SIZE := Vector2(64, 16)

const BUMP_SHAKE_INTENSITY: float = 2.0

#endregion

#region Variables

@export var _missile_texture: TextureRect
@export var _body_collision_shape: CollisionShape2D
@export var _head_area: Area2D

var missile_data: MissileData = MissileData.new(
	Vector2i.ZERO, Enums.MissileColorType.RED, Enums.MissileSizeType.SMALL, Enums.Direction4Way.DOWN)

var _is_initialized: bool = false

var _state: MoveState
var _origin_position: Vector2

var _bump_tween: Tween

#region Callable

var _callable_context: MissilePuzzleCallableContext
var _get_is_missile_exited_board: Callable
var _equip_missile_callable: Callable

#endregion

#endregion

#region Lifecycle

func _ready():
	if DebugUtils.try_center_if_root(self):
		initialize(missile_data, true)

func initialize(data: MissileData,
	is_root: bool = false,
	callable_context: MissilePuzzleCallableContext = MissilePuzzleCallableContext.new(),
	get_is_missile_exited_board: Callable = Callable(),
	equip_missile_callable: Callable = Callable()) -> void:
	if _is_initialized:
		return

	missile_data = data
	_callable_context = callable_context
	_get_is_missile_exited_board = get_is_missile_exited_board
	_equip_missile_callable = equip_missile_callable
	
	_clear_collision_events();
	_head_area.monitoring = false

	_setup_size()
	_load_sprite()
	_setup_rotation()
	if not is_root:
		position = Vector2(
			missile_data.grid_pos.x * Consts.MISSILE_PUZZLE_BOARD_CELL_SIZE, 
			missile_data.grid_pos.y * Consts.MISSILE_PUZZLE_BOARD_CELL_SIZE) \
			 + _get_grid_pos_offset()

	_state = MoveState.IDLE

	_is_initialized = true

func _process(delta: float) -> void:
	match _state:
		MoveState.IDLE:
			pass
		MoveState.SETUP_FOR_MOVE:
			setup_for_move()
		MoveState.WAIT_MOVE:
			wait_move(delta)
		MoveState.MOVE_FOR_EQUIP:
			move_for_equip(delta)
		MoveState.BUMPED:
			bumped(delta)
		MoveState.RETURN_TO_ORIGIN:
			move_to_origin(delta)
		MoveState.WAIT_EXIT:
			wait_leave(delta)
		MoveState.EXITED_BOARD:
			pass

#endregion

#region Event Methods

func _gui_input(event: InputEvent) -> void:
	if _state != MoveState.IDLE \
		or _get_is_missile_exited_board.is_null():
		return

	if event is InputEventMouseButton and event.pressed \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and not _callable_context.get_is_full_missile_slot_callable.call():
		_state = MoveState.SETUP_FOR_MOVE

#endregion

#region Methods

#region On Initialize

func _setup_size():
	match missile_data.size:
		Enums.MissileSizeType.SMALL:
			size = SMALL_SIZE
		Enums.MissileSizeType.MEDIUM:
			size = MEDIUM_SIZE
		Enums.MissileSizeType.LARGE:
			size = LARGE_SIZE
	pivot_offset = size * 0.5

	_body_collision_shape.position = pivot_offset
	_body_collision_shape.scale = pivot_offset * 0.1

func _load_sprite():
	var sprite_path := missile_data.get_my_sprite_path()
	var texture := load(sprite_path) as Texture2D
	if texture:
		_missile_texture.texture = texture
	else:
		LogManager.error("Sprite Load Fail: %s" % sprite_path, "MissilePuzzlePiece")

func _setup_rotation():
	match missile_data.direction:
		Enums.Direction4Way.LEFT:
			rotation_degrees = 0
		Enums.Direction4Way.UP:
			rotation_degrees = 90
		Enums.Direction4Way.RIGHT:
			rotation_degrees = 180
		Enums.Direction4Way.DOWN:
			rotation_degrees = -90

#endregion

#region Grid

func _get_grid_pos_offset() -> Vector2:
	match missile_data.direction:
		Enums.Direction4Way.LEFT:
			return Vector2(pivot_offset.x, pivot_offset.y)
		Enums.Direction4Way.UP:
			return Vector2(size.y - pivot_offset.x, size.x - pivot_offset.y)
		Enums.Direction4Way.RIGHT:
			return Vector2(pivot_offset.x, pivot_offset.y)
		Enums.Direction4Way.DOWN:
			return Vector2(size.y - pivot_offset.x, size.x - pivot_offset.y)
		_:
			return Vector2(0, 0)

static func get_is_on_board(grid_size: Vector2i, grid_pos: Vector2i,
	missile_size: Enums.MissileSizeType, direction: Enums.Direction4Way) -> bool:
	var min_pos := grid_pos
	var max_pos := grid_pos
	var length := MissileData.get_missile_grid_length(missile_size)
	
	if (direction == Enums.Direction4Way.LEFT
		or direction == Enums.Direction4Way.RIGHT):
		max_pos.x = grid_pos.x + length - 1
	elif (direction == Enums.Direction4Way.UP
		or direction == Enums.Direction4Way.DOWN):
		max_pos.y = grid_pos.y + length - 1

	return (min_pos.x >= 0 and max_pos.x < grid_size.x
		and min_pos.y >= 0 and max_pos.y < grid_size.y)

func get_my_grid_cells() -> Array[Vector2i]:
	return get_grid_cells(Vector2i(Consts.MISSILE_PUZZLE_BOARD_GRID_WIDTH, Consts.MISSILE_PUZZLE_BOARD_GRID_HEIGHT),
		missile_data.grid_pos, missile_data.size, missile_data.direction)

static func get_grid_cells(grid_size: Vector2i, grid_pos: Vector2i,
	missile_size: Enums.MissileSizeType, direction: Enums.Direction4Way) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	
	var offset := Vector2i.ZERO
	match direction:
		Enums.Direction4Way.LEFT:
			offset = Vector2i(1, 0)
		Enums.Direction4Way.UP:
			offset = Vector2i(0, 1)
		Enums.Direction4Way.RIGHT:
			offset = Vector2i(1, 0)
		Enums.Direction4Way.DOWN:
			offset = Vector2i(0, 1)
		_:
			offset = Vector2i.ZERO

	var length := MissileData.get_missile_grid_length(missile_size)

	for i in length:
		var pos = grid_pos + offset * i
		if pos.x < 0 or pos.x >= grid_size.x or pos.y < 0 or pos.y >= grid_size.y:
			break

		result.append(pos)

	return result

func get_missile_real_length() -> float:
	return missile_data.get_my_real_length() / scale.x

#endregion

#region Move

func setup_for_move() -> void:
	_state = MoveState.WAIT_MOVE
	_origin_position = position
	_add_collision_event_when_moved()
	_head_area.monitoring = true
	_callable_context.reserve_missile_slot_callable.call()

func wait_move(delta: float) -> void:
	_state = MoveState.MOVE_FOR_EQUIP

func move_for_equip(delta: float) -> void:
	var move_vector := EnumUtils.direction_to_vector(missile_data.direction)
	position += move_vector * MISSILE_CONFIG.move_speed * delta
	if(_get_is_missile_exited_board.call(self)):
		_state = MoveState.WAIT_EXIT
		
func bumped(delta: float) -> void:
	if(_bump_tween == null):
		var shake_offset := _get_shake_offset()
		var base_pos := position

		_bump_tween = create_tween()
		_bump_tween.set_ease(Tween.EASE_OUT)
		_bump_tween.set_trans(Tween.TRANS_SINE)
	
		for i in range(3):
			var intensity := BUMP_SHAKE_INTENSITY * (1.0 - i * 0.25)
			_bump_tween.tween_property(self, "position", 
				base_pos + shake_offset * intensity, 0.05)
			_bump_tween.tween_property(self, "position", 
				base_pos - shake_offset * intensity, 0.05)
		_bump_tween.tween_property(self, "position", base_pos, 0.03)
	elif not _bump_tween.is_running():
		_bump_tween = null
		_state = MoveState.RETURN_TO_ORIGIN

func move_to_origin(delta: float) -> void:
	pass

func wait_leave(delta: float) -> void:
	_state = MoveState.EXITED_BOARD
	_equip_missile_callable.call(self)
	LogManager.info("Missile Exited Board: %s" % missile_data.grid_pos, "MissilePuzzlePiece")

#endregion

#region Collision

func _clear_collision_events() -> void:
	for connection in _head_area.get_signal_connection_list("area_entered"):
		_head_area.area_entered.disconnect(connection["callable"])

func _add_collision_event_when_moved() -> void:
	_head_area.area_entered.connect(_check_collision_when_moved)

func _check_collision_when_moved(other_area: Area2D) -> void:
	var other = other_area.owner as MissilePuzzlePiece
	if other == null or other == self:
		return

	_clear_collision_events()
	_callable_context.unreserve_missile_slot_callable.call()
	_state = MoveState.BUMPED

#endregion

func _get_shake_offset() -> Vector2:
	match missile_data.direction:
		Enums.Direction4Way.LEFT:
			return Vector2(1, 0)
		Enums.Direction4Way.RIGHT:
			return Vector2(-1, 0)
		Enums.Direction4Way.UP:
			return Vector2(0, 1)
		Enums.Direction4Way.DOWN:
			return Vector2(0, -1)
		_:
			return Vector2(0, 1)

#endregion
