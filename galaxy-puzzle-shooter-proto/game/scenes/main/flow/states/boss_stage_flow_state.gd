# boss_stage_flow_state.gd
class_name BossStageFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
	return StateType.BOSS_STAGE

func begin() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	await tree.create_timer(0.2).timeout

	_context.missile_puzzle_board.set_input_enable(false)
	await _perform_boss_warning()
	await tree.create_timer(0.5).timeout

	_context.boss_enemy_ui.visible = true
	_context.enemy_service.spawn_boss_enemy(
		_context.stage_config.boss_enemy,
		_context.boss_enemy_ui,
		spawn_random_enemy,
		_context.enemy_service.despawn_enemy)

	_context.missile_puzzle_board.set_input_enable(true)

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
	if get_is_game_over():
		return StateType.GAME_OVER

	if get_is_clear_boss_stage():
		_context.boss_enemy_ui.visible = false
		return StateType.STAGE_CLEAR
		
	return StateType.NONE

func end() -> void:
	_context.missile_puzzle_board.set_input_enable(false)

#endregion

#region Methods

func _perform_boss_warning() -> void:
	var warning_text := _context.boss_warning_text
	warning_text.modulate.a = 0.0
	warning_text.show()
	var warning_sfx := SoundManager.play_sfx("boss_warning", true)

	var tree := Engine.get_main_loop() as SceneTree
	var tween = tree.create_tween()
	for i in range(4):
		tween.tween_property(warning_text, "modulate:a", 1.0, 0.2)
		tween.tween_interval(0.5)
		tween.tween_property(warning_text, "modulate:a", 0.0, 0.2)
		tween.tween_interval(0.2)
	await tween.finished
	SoundManager.stop_sfx(warning_sfx)
	
	warning_text.hide()

func get_is_game_over() -> bool:
	return _context.player.state == Character.StateType.DEAD

func get_is_clear_boss_stage() -> bool:
	if _context.enemy_service.boss_enemy.state == Character.StateType.DEAD:
		return true
	else:
		return false

#region Spawn Methods

func spawn_random_enemy(spawn_index: int) -> Enemy:
	var config_index: int = randi() % _context.stage_config.enemy_list.size()
	var key: String = _context.stage_config.enemy_list[config_index]
	var result: Enemy = _context.enemy_service.spawn_enemy(key, spawn_index)
	return result

#endregion

#endregion