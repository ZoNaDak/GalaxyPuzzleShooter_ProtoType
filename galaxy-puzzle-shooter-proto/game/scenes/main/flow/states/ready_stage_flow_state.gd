# ready_stage_flow_state.gd
class_name ReadyStageFlowState

extends MainFlowState

#region Variables

var _wait_cur_time: float

#endregion

#region Override Methods

func get_state_type() -> StateType:
	return StateType.READY_STAGE

func begin() -> void:
	_wait_cur_time = 0.0
	_context.game_start_text.visible = true
	SoundManager.play_bgm("Drifting Over Dark Orbits", true)

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
	if _wait_cur_time >= Consts.READY_STAGE_WAIT_DURATION:
		return StateType.COMMON_STAGE
	_wait_cur_time += delta_time
	return StateType.NONE

func end() -> void:
	_context.game_start_text.visible = false

#endregion