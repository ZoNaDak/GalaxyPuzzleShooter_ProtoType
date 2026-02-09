# effect_service.gd
class_name EffectService

extends Node

#region Consts

const EFFECT_SCENE_PATH: String = "res://game/effects/%s.tscn"

#endregion

#region Variables

@export var _effect_parent: Node2D

var _effect_arr: Array[GPUParticles2D] = []

#endregion

#region Methods

func play_effect(key: String, pos: Vector2) -> GPUParticles2D:
	LogManager.info("play_effect : %s, %s" % [key, pos], "EffectService")
	var effect_scene: PackedScene = load(EFFECT_SCENE_PATH % [key])
	if effect_scene == null:
		LogManager.warning("Effect Scene is null : %s" % [key], "EffectService")
		return
	var effect: GPUParticles2D = effect_scene.instantiate()
	effect.global_position = pos
	effect.emitting = true
	effect.finished.connect(func(): stop_effect(effect))
	_effect_parent.add_child(effect)
	_effect_arr.append(effect)
	return effect

func stop_effect(effect: GPUParticles2D) -> void:
	_effect_arr.erase(effect)
	effect.queue_free()

#endregion
