# game_over_flow_state.gd
class_name GameOverFlowState

extends MainFlowState

#region Variables

var _wait_cur_time: float

#endregion

#region Override Methods

func get_state_type() -> StateType:
	return StateType.GAME_OVER

func begin() -> void:
	_wait_cur_time = 0.0
	_context.game_over_text.visible = true

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
	if _wait_cur_time >= Consts.GAME_OVER_WAIT_DURATION:
		return StateType.LEAVE_STAGE
	_wait_cur_time += delta_time
	return StateType.NONE

func end() -> void:
	_context.game_over_text.visible = false

#endregion