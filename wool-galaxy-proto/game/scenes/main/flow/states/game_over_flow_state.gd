# game_over_flow_state.gd
class_name GameOverFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
    return StateType.GAME_OVER

func begin() -> void:
    pass

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
    return StateType.NONE

func end() -> void:
    pass

#endregion