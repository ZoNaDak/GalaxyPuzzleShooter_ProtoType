#main_flow.gd
class_name MainFlow

extends Node    

#region Consts

const StateType = MainFlowState.StateType

#endregion

#region Variables

var _states: Dictionary[StateType, MainFlowState] = {}
var _cur_state: MainFlowState

var _is_change_state: bool = false

#endregion

#region Properties

var cur_state_type: StateType:
    get:
        if _cur_state == null:
            return StateType.NONE
        else:
            return _cur_state.get_state_type()

#endregion

#region Lifecycle

func initialize(context: MainFlowContext) -> void:
    for i in range(0, StateType.COUNT):
        var state_type: StateType = i as StateType
        var state: MainFlowState = MainFlowState.create(state_type)
        state.initialize(context)
        _states[state_type] = state

func _process(delta: float) -> void:
    if _cur_state == null or _is_change_state:
        return

    var next_state_type: StateType = _cur_state.update(delta)
    if next_state_type != StateType.NONE:
        change_flow(next_state_type)

#endregion

#region Methods

func start_flow() -> void:
    change_flow(StateType.SETUP_STAGE)

@warning_ignore("redundant_await")
func change_flow(new_state_type: StateType) -> void:
    LogManager.info("change_flow: %s -> %s" \
        % [StateType.find_key(cur_state_type), StateType.find_key(new_state_type)], \
        "MainFlow")

    _is_change_state = true

    if _cur_state != null:
        await _cur_state.end()
    _cur_state = _states[new_state_type]
    await _cur_state.begin()

    _is_change_state = false

#endregion