# base_scene.gd
class_name BaseScene

extends Node

#region Signals

#endregion

#region Variables

#endregion

#region Lifecycle

func _ready() -> void:
	if GameManager.current_state == GameManager.GameState.NONE:
		GameManager.init_state(_get_scene_state())

#endregion

#region Methods

## 추상 메서드 - 자식 클래스에서 반드시 오버라이드해야 함
func _get_scene_state() -> GameManager.GameState:
	assert(false, "Must override _get_scene_state()")
	return GameManager.GameState.NONE

#endregion
