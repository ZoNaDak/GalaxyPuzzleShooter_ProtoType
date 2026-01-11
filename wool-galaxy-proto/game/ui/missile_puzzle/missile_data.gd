#missile_data.gd
class_name MissileData

#region Variables

var grid_pos: Vector2i
var color: Enums.MissileColorType
var size: Enums.MissileSizeType
var direction: Enums.Direction4Way

#endregion
	
#region Lifecycle

func _init(p: Vector2i, c: Enums.MissileColorType, 
	s: Enums.MissileSizeType, d: Enums.Direction4Way):
	grid_pos = p
	color = c
	size = s
	direction = d

#endregion