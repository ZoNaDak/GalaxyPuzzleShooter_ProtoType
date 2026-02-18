# leave_stage_flow_state.gd
class_name LeaveStageFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
	return StateType.LEAVE_STAGE

func begin() -> void:
	await SystemUIManager.fade_out(0.5)
	GameManager.change_state(GameManager.GameState.TITLE)

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
	return StateType.NONE

func end() -> void:
	pass

#endregion