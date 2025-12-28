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

#region Constants

const SCENES := {
	GameState.TITLE: "res://game/scenes/title/title_scene.tscn",
	GameState.MAIN: "res://game/scenes/main/main_scene.tscn",
}

#endregion

#region Variables

var current_state: GameState = GameState.NONE

#endregion

#region Methods

func init_state(new_state: GameState) -> void:
	LogManager.info("init_state: %s" % GameState.keys()[new_state], "GameManager")
	current_state = new_state

func change_state(new_state: GameState) -> void:
	if current_state == new_state:
		return
	var old_state := current_state
	current_state = new_state
	LogManager.info("change_state: %s -> %s" % [GameState.keys()[old_state], GameState.keys()[new_state]], "GameManager")
	state_changed.emit(new_state)
	_change_scene(new_state)

func _change_scene(state: GameState) -> void:
	if state in SCENES:
		get_tree().change_scene_to_file(SCENES[state])
	else:
		LogManager.warning("No scene defined for state: %s" % GameState.keys()[state], "GameManager")

#endregion

