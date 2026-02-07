# setup_stage_flow_state.gd
class_name SetupStageFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
	return StateType.SETUP_STAGE

func begin() -> void:
	var player_callable_context := PlayerCallableContext.new()
	player_callable_context.initialize(
		_context.projectile_service.spawn_bullet,
		_context.enemy_service.get_enemy_spawn_point_arr,
		_context.enemy_service.get_locked_enemy,
		_context.player_ui.set_cur_hp,
		_context.player_ui.set_cur_mp)
	_context.player.initialize(player_callable_context)
	_context.player_ui.initialize(_context.player.player_data)
	_context.reset_button.initialize()
	_context.missile_slot_board.initialize()
	
	var missile_puzzle_callable_context := MissilePuzzleCallableContext.new()
	missile_puzzle_callable_context.initialize(
		_context.player.player_data.get_is_full_missile_slot,
		_context.player.player_data.reserve_missile_slot,
		_context.player.player_data.unreserve_missile_slot,
		_context.player.player_data.equip_missile)
	_context.missile_puzzle_board.initialize(
		_context.reset_button,
		missile_puzzle_callable_context)
	_context.missile_puzzle_board.set_input_enable(false)

	_context.player.player_data.on_equip_missile.connect(
		_context.missile_slot_board.on_equip_missile)
	_context.player.player_data.on_unequip_missile.connect(
		_context.missile_slot_board.on_unequip_missile)

	await SystemUIManager.fade_in(0.5)

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
	return StateType.READY_STAGE

func end() -> void:
	pass

#endregion
