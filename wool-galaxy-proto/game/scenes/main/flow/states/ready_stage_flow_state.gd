# ready_stage_flow_stage.gd
class_name ReadyStageFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
    return StateType.READY_STAGE

func begin() -> void:
    pass

func update(deltaTime: float) -> StateType:
    return StateType.COMMON_STAGE

func end() -> void:
    pass

#endregion