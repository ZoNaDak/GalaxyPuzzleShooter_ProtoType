# enemy.gd
class_name Enemy

extends Character

#region Consts

const ENEMY_SPAWN_Y_DIST: float = 100.0

#endregion

#region Variables

@export var enemy_config: EnemyConfig

var enemy_data: EnemyData

var spawn_index: int
var _spawn_pos: Vector2

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize(spawn_index: int, spawn_pos: Vector2) -> void:
	self.spawn_index = spawn_index
	_spawn_pos = spawn_pos
	position = spawn_pos + Vector2(0, -ENEMY_SPAWN_Y_DIST)
	enemy_data = EnemyData.new(enemy_config.max_hp, enemy_config.max_mp)
	data = enemy_data
	state = StateType.START_MOVE

func _process(delta: float) -> void:
	match state:
		StateType.START_MOVE:
			start_move(delta)
		StateType.IDLE:
			pass

#endregion

#region Methods

func start_move(delta: float) -> void:
	var move_vector := enemy_config.move_speed * delta * Vector2.DOWN
	position += move_vector
	if position.y >= _spawn_pos.y:
		position = _spawn_pos
		state = StateType.IDLE

#endregion

#region Debug

func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if state != StateType.IDLE:
		return

	if event is InputEventKey and event.keycode == KEY_2 \
		and event.is_pressed() and not event.is_echo():
		die()

#endregion
