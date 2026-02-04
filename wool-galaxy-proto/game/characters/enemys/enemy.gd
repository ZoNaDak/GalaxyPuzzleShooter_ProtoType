# enemy.gd
class_name Enemy

extends Character

#region Consts

const ENEMY_SPAWN_Y_DIST: float = 100.0

#endregion

#region Variables

@export var enemy_config: EnemyConfig
@export var hp_ui: ProgressBar
@export var lock_on_ui: Node2D

var enemy_data: EnemyData

var spawn_index: int
var _spawn_pos: Vector2

#region Callable

var _lock_on_callable: Callable

#endregion

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize(spawn_index: int, spawn_pos: Vector2,
	lock_on_callable: Callable) -> void:
	self.spawn_index = spawn_index
	_spawn_pos = spawn_pos
	self._lock_on_callable = lock_on_callable

	position = spawn_pos + Vector2(0, -ENEMY_SPAWN_Y_DIST)
	enemy_data = EnemyData.new(enemy_config.max_hp, enemy_config.max_mp)
	data = enemy_data
	refresh_hp_ui()
	lock_on_ui.visible = false
	state = StateType.START_MOVE

func _process(delta: float) -> void:
	match state:
		StateType.START_MOVE:
			start_move(delta)
		StateType.IDLE:
			pass

#endregion

#region Input

func _input(event: InputEvent) -> void:
	_check_lock_on_input(event)
	_check_debug_input(event)

func _check_lock_on_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var distance = global_position.distance_to(mouse_pos)
		if distance < 10.0:
			lock_on()

#endregion

#region Override Methods

func get_type() -> Enums.CharacterType:
	return Enums.CharacterType.ENEMY

#endregion

#region Methods

func start_move(delta: float) -> void:
	var move_vector := enemy_config.move_speed * delta * Vector2.DOWN
	position += move_vector
	if position.y >= _spawn_pos.y:
		position = _spawn_pos
		state = StateType.IDLE

func lock_on() -> void:
	lock_on_ui.visible = true
	_lock_on_callable.call(self)

func lock_off() -> void:
	lock_on_ui.visible = false

func refresh_hp_ui() -> void:
	hp_ui.value = float(data.cur_hp) / float(data.max_hp) * 100.0

#endregion

#region Debug
	
func _check_debug_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if state != StateType.IDLE:
		return

	if event is InputEventKey and event.keycode == KEY_2 \
		and event.is_pressed() and not event.is_echo():
		die()

#endregion
