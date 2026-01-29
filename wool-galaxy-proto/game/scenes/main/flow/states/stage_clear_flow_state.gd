# stage_clear_flow_state.gd
class_name StageClearFlowState

extends MainFlowState

#region Variables

var _wait_cur_time: float

#endregion

#region Override Methods

func get_state_type() -> StateType:
	return StateType.STAGE_CLEAR

func begin() -> void:
	_wait_cur_time = 0.0
	_context.stage_clear_text.visible = true

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
	if _wait_cur_time >= Consts.STAGE_CLEAR_WAIT_DURATION:
		return StateType.LEAVE_STAGE
	_wait_cur_time += delta_time
	return StateType.NONE

func end() -> void:
	_context.stage_clear_text.visible = false

#endregion