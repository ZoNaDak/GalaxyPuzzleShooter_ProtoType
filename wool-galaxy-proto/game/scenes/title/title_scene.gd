# title_scene.gd
extends BaseScene

#region Signals

#endregion

#region Variables

#endregion

#region Lifecycle

#endregion

#region Methods

func _get_scene_state() -> GameManager.GameState:
	return GameManager.GameState.TITLE

#endregion

#region Signal Callbacks

func _on_start_button_pressed() -> void:
	GameManager.change_state(GameManager.GameState.MAIN)

#endregion
