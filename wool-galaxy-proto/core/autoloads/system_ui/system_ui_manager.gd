# system_ui_manager.gd
extends Node

#region Signals

signal fade_completed

#endregion

#region Variables

@export var _fade_rect: ColorRect

var _is_fading: bool = false

#endregion

#region Property

var is_faded: bool:
	get:
		return _fade_rect.visible

#endregion

#region Lifecycle

func _ready() -> void:
	_fade_rect.visible = false
	_fade_rect.modulate.a = 0.0
	_is_fading = false

#endregion

#region Methods

## 페이드 아웃 (화면 어두워짐)
func fade_out(duration: float) -> void:
	_is_fading = true

	_fade_rect.visible = true
	var tween := create_tween()
	tween.tween_property(_fade_rect, "modulate:a", 1.0, duration)
	await tween.finished
	fade_completed.emit()

	_is_fading = false

## 페이드 인 (화면 밝아짐)
func fade_in(duration: float) -> void:
	_is_fading = true

	var tween := create_tween()
	tween.tween_property(_fade_rect, "modulate:a", 0.0, duration)
	await tween.finished
	_fade_rect.visible = false
	fade_completed.emit()

	_is_fading = false

#endregion
