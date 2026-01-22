# stage_clear_flow_state.gd
class_name StageClearFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
    return StateType.STAGE_CLEAR

func begin() -> void:
    pass

@warning_ignore("unused_parameter")
func update(deltaTime: float) -> StateType:
    return StateType.NONE

func end() -> void:
    pass

#endregion