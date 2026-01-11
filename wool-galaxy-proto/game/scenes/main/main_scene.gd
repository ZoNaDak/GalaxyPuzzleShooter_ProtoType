# main_scene.gd
extends BaseScene

#region Signals

#endregion

#region Variables

#endregion

#region Lifecycle

func _ready() -> void:
	super._ready()
	await SystemUIManager.fade_in(0.5)

#endregion

#region Methods

func _get_scene_state() -> GameManager.GameState:
	return GameManager.GameState.MAIN

#endregion
