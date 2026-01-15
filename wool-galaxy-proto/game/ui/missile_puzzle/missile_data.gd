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

#region Methods

func get_my_sprite_path() -> String:
	return get_sprite_path(color, size)

static func get_sprite_path(color_type: Enums.MissileColorType, size_type: Enums.MissileSizeType) -> String:
	return "res://game/ui/missile_puzzle/missile_puzzle_pieces/resources/%s_missile_%s.png" \
		% [_get_color_name(color_type), _get_size_name(size_type)]

static func _get_color_name(color_type: Enums.MissileColorType) -> String:
	match color_type:
		Enums.MissileColorType.RED:
			return "red"
		Enums.MissileColorType.BLUE:
			return "blue"
		Enums.MissileColorType.GREEN:
			return "green"
		Enums.MissileColorType.YELLOW:
			return "yellow"
		Enums.MissileColorType.PURPLE:
			return "purple"
		_:
			return "red"

static func _get_size_name(size_type: Enums.MissileSizeType) -> String:
	match size_type:
		Enums.MissileSizeType.SMALL:
			return "s"
		Enums.MissileSizeType.MEDIUM:
			return "m"
		Enums.MissileSizeType.LARGE:
			return "l"
		_:
			return "m"

#endregion
