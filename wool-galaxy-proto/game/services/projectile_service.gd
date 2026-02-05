# projectile_service.gd
class_name ProjectileService

extends Node

#region Consts

const BULLET_SCENE_PATH: String = "res://game/projectiles/%s.tscn"

#endregion

#region Variables

@export var _projectile_parent: Node2D

var _projectile_arr: Array[ProjectileBase]

#endregion

#region Property

#endregion

#region Lifecycle

func initialize() -> void:
	pass

#endregion

#region Methods

func spawn_bullet(key: String) -> Bullet:
	LogManager.info("spawn_bullet : %s" % [key], "ProjectileService")
	var bullet_scene: PackedScene = load(BULLET_SCENE_PATH % [key])
	var bullet: Bullet = bullet_scene.instantiate()
	_projectile_parent.add_child(bullet)
	_projectile_arr.append(bullet)
	bullet.initialize(despawn_bullet)
	return bullet

func despawn_bullet(bullet: Bullet) -> void:
	_projectile_arr.erase(bullet)
	bullet.queue_free()

#endregion