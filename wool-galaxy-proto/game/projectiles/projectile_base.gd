# projectile_base.gd
class_name ProjectileBase

extends Node2D

func get_type() -> Enums.ProjectileType:
	assert(false, "Must override get_type()")
	return Enums.ProjectileType.NONE