# projectile_service.gd
class_name ProjectileService

extends Node

#region Consts

const PROJECTILE_SCENE_PATH: String = "res://game/projectiles/%s.tscn"

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
	var bullet_scene: PackedScene = load(PROJECTILE_SCENE_PATH % [key])
	var bullet: Bullet = bullet_scene.instantiate()
	_projectile_parent.add_child(bullet)
	_projectile_arr.append(bullet)
	bullet.initialize(despawn_projectile)
	return bullet

func spawn_laser(key: String) -> Laser:
	LogManager.info("spawn laser: %s" % [key], "ProjectileService")
	var laser_scene: PackedScene = load(PROJECTILE_SCENE_PATH % [key])
	var laser: Laser = laser_scene.instantiate()
	_projectile_parent.add_child(laser)
	_projectile_arr.append(laser)
	laser.initialize(despawn_projectile)
	return laser

func despawn_projectile(projectile: ProjectileBase) -> void:
	_projectile_arr.erase(projectile)
	projectile.queue_free()

#endregion
