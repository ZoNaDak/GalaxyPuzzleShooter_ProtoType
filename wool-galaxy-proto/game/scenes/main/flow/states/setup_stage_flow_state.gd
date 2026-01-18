# setup_stage_flow_state.gd
class_name SetupStageFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
    return StateType.SETUP_STAGE

func begin() -> void:
    pass

func update(deltaTime: float) -> void:
    pass

func end() -> void:
    pass

#endregion