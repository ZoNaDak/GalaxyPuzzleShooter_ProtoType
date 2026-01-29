# boss_stage_flow_state.gd
class_name BossStageFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
	return StateType.BOSS_STAGE

func begin() -> void:
	pass

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
	if true:
		return StateType.STAGE_CLEAR
		
	return StateType.NONE

func end() -> void:
	pass

#endregion