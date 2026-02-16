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

	_context.enemy_service.spawn_boss_enemy(_context.stage_config.boss_enemy)

	_context.missile_puzzle_board.set_input_enable(true)

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
	# TODO: 추후 플로우 구현할 것
	if false:
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
	
	var tree := Engine.get_main_loop() as SceneTree
	var tween = tree.create_tween()
	for i in range(4):
		tween.tween_property(warning_text, "modulate:a", 1.0, 0.2)
		tween.tween_interval(0.5)
		tween.tween_property(warning_text, "modulate:a", 0.0, 0.2)
		tween.tween_interval(0.2)
	await tween.finished
	
	warning_text.hide()
	

#endregion