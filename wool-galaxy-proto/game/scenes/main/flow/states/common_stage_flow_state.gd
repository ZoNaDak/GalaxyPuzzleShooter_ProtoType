# common_stage_flow_state.gd
class_name CommonStageFlowState

extends MainFlowState

#region Variables

#endregion

#region Override Methods

func get_state_type() -> StateType:
    return StateType.COMMON_STAGE

func begin() -> void:
    for i in range(0, 3):
        var config_index: int = randi() % _context.stage_config.enemy_list.size()
        var key: String = _context.stage_config.enemy_list[config_index]
        _context.enemy_service.spawn_enemy(key, i)

@warning_ignore("unused_parameter")
func update(delta_time: float) -> StateType:
    
    return StateType.NONE

func end() -> void:
    pass

#endregion