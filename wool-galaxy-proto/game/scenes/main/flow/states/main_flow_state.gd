# main_flow_state.gd
class_name MainFlowState

#region Enums

enum StateType 
{
    NONE = -1,
    SETUP_STAGE,
    READY_STAGE,
    COMMON_STAGE,
    BOSS_STAGE,
    STAGE_CLEAR,
    GAME_OVER,
    LEAVE_STAGE,
    COUNT,
}

#endregion

#region Consts

const STATE_PATH_FORMAT: String = "res://game/scenes/main/flow/states/%s_flow_state.gd"

#endregion

#region Variables

var _context: MainFlowContext

#endregion

#region Lifecycle

func initialize(context: MainFlowContext) -> void:
    self._context = context

#endregion

#region Factory Methods

static func create(state_type: StateType) -> MainFlowState:
    var enum_name: String = StateType.find_key(state_type)
    var state_name: String = enum_name.to_lower()
    
    var script_path: String = STATE_PATH_FORMAT % state_name
    var script: Script = load(script_path)
    return script.new()

#endregion

#region Abstract Methods

func get_state_type() -> StateType:
    assert(false, "Must override get_state_type()")
    return StateType.NONE

func begin() -> void:
    assert(false, "Must override begin()")

@warning_ignore("unused_parameter")
func update(deltaTime: float) -> StateType:
    assert(false, "Must override update()")
    return StateType.NONE

func end() -> void:
    assert(false, "Must override end()")

#endregion