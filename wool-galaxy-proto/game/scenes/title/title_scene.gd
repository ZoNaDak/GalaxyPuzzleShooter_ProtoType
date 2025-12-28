# title_scene.gd
extends BaseScene

#region Signals

#endregion

#region Variables

var _is_changing_scene: bool = false

#endregion

#region Lifecycle

func _ready() -> void:
	super._ready()
	_is_changing_scene = false

#endregion

#region Methods

func _get_scene_state() -> GameManager.GameState:
	return GameManager.GameState.TITLE

#endregion

#region Signal Callbacks

func _on_start_button_pressed() -> void:
	if _is_changing_scene:
		return
	_is_changing_scene = true

	await SystemUIManager.fade_out(0.5)
	GameManager.change_state(GameManager.GameState.MAIN)

#endregion
