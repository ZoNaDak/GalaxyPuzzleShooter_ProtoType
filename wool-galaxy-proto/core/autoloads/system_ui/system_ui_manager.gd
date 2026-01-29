# system_ui_manager.gd
extends Node

#region Variables

@export var _fade_rect: ColorRect

var _fade_tween: Tween = null

#endregion

#region Property

var is_fading: bool:
	get:
		return _fade_tween != null and _fade_tween.is_running()

var is_faded: bool:
	get:
		return _fade_rect.visible

#endregion

#region Lifecycle

func _ready() -> void:
	_fade_rect.visible = false
	_fade_rect.modulate.a = 0.0
	_fade_tween = null

#endregion

#region Methods

func fade_out(duration: float) -> void:
	if _fade_tween != null and _fade_tween.is_running():
		_fade_tween.kill()

	_fade_rect.visible = true
	_fade_tween = create_tween()
	_fade_tween.tween_property(_fade_rect, "modulate:a", 1.0, duration)
	await _fade_tween.finished

func fade_in(duration: float) -> void:
	if _fade_tween != null and _fade_tween.is_running():
		_fade_tween.kill()

	_fade_tween = create_tween()
	_fade_tween.tween_property(_fade_rect, "modulate:a", 0.0, duration)
	await _fade_tween.finished
	_fade_rect.visible = false

#endregion
