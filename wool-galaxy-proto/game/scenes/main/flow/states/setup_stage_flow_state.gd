# setup_stage_flow_state.gd
class_name SetupStageFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
    return StateType.SETUP_STAGE

func begin() -> void:
    _context.player.initialize()
    _context.player_ui.initialize(_context.player.player_data)
    _context.missile_slot_board.initialize()
    _context.missile_puzzle_board.initialize()

    await SystemUIManager.fade_in(0.5)

@warning_ignore("unused_parameter")
func update(deltaTime: float) -> StateType:
    return StateType.READY_STAGE

func end() -> void:
    pass

#endregion