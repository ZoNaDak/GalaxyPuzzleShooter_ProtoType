# reset_button.gd
class_name ResetButton

extends Control

#region Variables

@export var _button: Button
@export var _cooltime_ui: TextureProgressBar

#region Callable

var _on_pressed_callable: Callable

#endregion

#endregion

#region Lifecycle

func initialize() -> void:
	_cooltime_ui.value = 0
	pass

#endregion

#region Signal Handlers

func _on_pressed() -> void:
	if not _on_pressed_callable.is_valid():
		return

	_on_pressed_callable.call()

#endregion

#region Methods

func set_on_pressed_callable(callable: Callable) -> void:
	_on_pressed_callable = callable

func set_cooltime_value(value: float) -> void:
	value *= 100.0
	LogManager.info("set_cooltime_value : %f" % value, "ResetButton")
	_cooltime_ui.value = value

#endregion
