# common_stage_flow_state.gd
class_name CommonStageFlowState

extends MainFlowState

#region Variables

var _enemy_spawn_delay_arr: Array[float] = []
var _enemy_spawn_count: int

#endregion

#region Override Methods

func get_state_type() -> StateType:
	return StateType.COMMON_STAGE

func begin() -> void:
	_enemy_spawn_count = 0
	for i in range(0, _context.enemy_service.enemy_spawn_count_max):
		spawn_random_enemy(i)
		_enemy_spawn_delay_arr.append(-1.0)

	_context.missile_puzzle_board.set_input_enable(true)

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
	if get_is_game_over():
		return StateType.GAME_OVER

	check_enemy_spawn(delta_time)
	check_enemy_die()

	if (get_is_clear_common_stage()):
		return StateType.BOSS_STAGE

	return StateType.NONE

func end() -> void:
	_context.missile_puzzle_board.set_input_enable(false)

#endregion

#region Methods

#region Check Update Methods

func get_is_game_over() -> bool:
	return _context.player.state == Character.StateType.DEAD

func check_enemy_spawn(delta_time: float) -> void:
	if get_is_all_spawned():
		return

	for i in range(_enemy_spawn_delay_arr.size()):
		if _context.enemy_service.enemy_arr[i] != null or get_is_all_spawned():
			continue

		_enemy_spawn_delay_arr[i] -= delta_time
		if _enemy_spawn_delay_arr[i] <= 0:
			spawn_random_enemy(i)
			_enemy_spawn_delay_arr[i] = -1.0

func check_enemy_die() -> void:
	var spawn_delay_min := _context.stage_config.enemy_spawn_delay_min_max.x
	var spawn_delay_max := _context.stage_config.enemy_spawn_delay_min_max.y

	for enemy in _context.enemy_service.enemy_arr:
		if enemy != null and enemy.state == Character.StateType.DEAD:
			var spawn_delay = randf_range(spawn_delay_min, spawn_delay_max)
			_enemy_spawn_delay_arr[enemy.spawn_index] = spawn_delay
			_context.enemy_service.despawn_enemy(enemy.spawn_index)

func get_is_all_spawned() -> bool:
	return _enemy_spawn_count >= _context.stage_config.enemy_spawn_total_count

func get_is_clear_common_stage() -> bool:
	var is_enemy_all_dead = true
	for enemy in _context.enemy_service.enemy_arr:
		if (enemy != null):
			is_enemy_all_dead = false
			break

	return get_is_all_spawned() and is_enemy_all_dead

#endregion

#region Spawn Methods

func spawn_random_enemy(spawn_index: int) -> void:
	var config_index: int = randi() % _context.stage_config.enemy_list.size()
	config_index = 1
	var key: String = _context.stage_config.enemy_list[config_index]
	_context.enemy_service.spawn_enemy(key, spawn_index)
	_enemy_spawn_count += 1

#endregion

#endregion