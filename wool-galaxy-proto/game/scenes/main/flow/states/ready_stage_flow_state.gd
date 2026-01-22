# ready_stage_flow_state.gd
class_name ReadyStageFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
    return StateType.READY_STAGE

func begin() -> void:
    pass

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
    return StateType.COMMON_STAGE

func end() -> void:
    pass

#endregion