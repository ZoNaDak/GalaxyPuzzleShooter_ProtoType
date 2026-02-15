# projectile_base.gd
class_name ProjectileBase

extends Node2D

#region Variables

var character_type: Enums.CharacterType

var damage: int

#endregion

#region Abstract Methods

func get_type() -> Enums.ProjectileType:
	assert(false, "Must override get_type()")
	return Enums.ProjectileType.NONE

#endregion