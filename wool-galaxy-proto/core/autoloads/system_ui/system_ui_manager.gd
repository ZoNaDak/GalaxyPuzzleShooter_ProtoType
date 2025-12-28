# system_ui_manager.gd
extends Node

#region Signals

signal fade_completed

#endregion

#region Variables

@export var _fade_rect: ColorRect

#endregion

#region Lifecycle

func _ready() -> void:
	_fade_rect.visible = false
	_fade_rect.modulate.a = 0.0

#endregion

#region Methods

## 페이드 아웃 (화면 어두워짐)
func fade_out(duration: float) -> void:
	_fade_rect.visible = true
	var tween := create_tween()
	tween.tween_property(_fade_rect, "modulate:a", 1.0, duration)
	await tween.finished
	fade_completed.emit()

## 페이드 인 (화면 밝아짐)
func fade_in(duration: float) -> void:
	var tween := create_tween()
	tween.tween_property(_fade_rect, "modulate:a", 0.0, duration)
	await tween.finished
	_fade_rect.visible = false
	fade_completed.emit()

#endregion
