# missile_puzzle_piece.gd
extends Control

class_name MissilePuzzlePiece

#region Consts

const SMALL_SIZE := Vector2(32, 16)
const MEDIUM_SIZE := Vector2(48, 16)
const LARGE_SIZE := Vector2(64, 16)

#endregion

#region Variables

@export var _missile_texture: TextureRect

var missile_data: MissileData = MissileData.new(
	Vector2i.ZERO, Enums.MissileColorType.RED, Enums.MissileSizeType.SMALL, Enums.Direction4Way.DOWN)

var _is_initialized: bool = false

#endregion

#region Lifecycle

func _ready():
	if DebugUtils.try_center_if_root(self):
		initialize(missile_data, true)

func initialize(data: MissileData, is_root: bool = false):
	if _is_initialized:
		return

	missile_data = data

	_setup_size()
	_load_sprite()
	_setup_rotation()
	if not is_root:
		position = Vector2(
			missile_data.grid_pos.x * Consts.MISSILE_PUZZLE_BOARD_CELL_SIZE, 
			missile_data.grid_pos.y * Consts.MISSILE_PUZZLE_BOARD_CELL_SIZE) + _get_grid_pos_offset()

	# LogManager.info("initialize : %s %s %s" % 
	# 	 [missile_data.grid_pos, _get_grid_pos_offset(), position], 
	# 	 "MissilePuzzlePiece")

	_is_initialized = true

#endregion

#region Methods

#region OnReady

func _setup_size():
	match missile_data.size:
		Enums.MissileSizeType.SMALL:
			size = SMALL_SIZE
		Enums.MissileSizeType.MEDIUM:
			size = MEDIUM_SIZE
		Enums.MissileSizeType.LARGE:
			size = LARGE_SIZE
	pivot_offset = size / 2.0

func _load_sprite():
	var sprite_path := _get_sprite_path()
	var texture := load(sprite_path) as Texture2D
	if texture:
		_missile_texture.texture = texture
		# LogManager.info("Sprite Load Success: %s" % sprite_path, "MissilePuzzlePiece")
	else:
		LogManager.error("Sprite Load Fail: %s" % sprite_path, "MissilePuzzlePiece")

func _get_sprite_path() -> String:
	return "res://game/ui/missile_puzzle/missile_puzzle_pieces/resources/%s_missile_%s.png" % [_get_color_name(), _get_size_name()]

func _get_color_name() -> String:
	match missile_data.color:
		Enums.MissileColorType.RED:
			return "red"
		Enums.MissileColorType.BLUE:
			return "blue"
		Enums.MissileColorType.GREEN:
			return "green"
		Enums.MissileColorType.YELLOW:
			return "yellow"
		Enums.MissileColorType.PURPLE:
			return "purple"
		_:
			return "red"

func _get_size_name() -> String:
	match missile_data.size:
		Enums.MissileSizeType.SMALL:
			return "s"
		Enums.MissileSizeType.MEDIUM:
			return "m"
		Enums.MissileSizeType.LARGE:
			return "l"
		_:
			return "m"

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
	var length := _get_missile_length(missile_size)
	
	if (direction == Enums.Direction4Way.LEFT
		or direction == Enums.Direction4Way.RIGHT):
		max_pos.x = grid_pos.x + length - 1
	elif (direction == Enums.Direction4Way.UP
		or direction == Enums.Direction4Way.DOWN):
		max_pos.y = grid_pos.y + length - 1

	return (min_pos.x >= 0 and max_pos.x < grid_size.x
		and min_pos.y >= 0 and max_pos.y < grid_size.y)

static func _get_missile_length(missile_size: Enums.MissileSizeType) -> int:
	match missile_size:
		Enums.MissileSizeType.SMALL:
			return 2
		Enums.MissileSizeType.MEDIUM:
			return 3
		Enums.MissileSizeType.LARGE:
			return 4
		_:
			return 1

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

	var length := _get_missile_length(missile_size)

	for i in length:
		var pos = grid_pos + offset * i
		if pos.x < 0 or pos.x >= grid_size.x or pos.y < 0 or pos.y >= grid_size.y:
			break

		result.append(pos)

	return result

#endregion

#endregion
