# game_manager.gd
extends Node

#region Enums
enum GameState {
	NONE,
	TITLE,
	MAIN,
}
#endregion

#region Signals
signal state_changed(new_state: GameState)
#endregion

#region Variables
var current_state: GameState = GameState.NONE
#endregion

#region Methods
func change_state(new_state: GameState) -> void:
	if current_state == new_state:
		return
	current_state = new_state
	state_changed.emit(new_state)
#endregion

