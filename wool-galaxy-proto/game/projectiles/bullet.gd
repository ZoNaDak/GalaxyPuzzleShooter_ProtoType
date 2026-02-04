# bullet.gd
class_name Bullet

extends ProjectileBase

#region Override Methods

func get_type() -> Enums.ProjectileType:
	return Enums.ProjectileType.BULLET

#endregion
