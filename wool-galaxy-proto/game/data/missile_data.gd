#missile_data.gd
class_name MissileData

#region Variables

var grid_pos: Vector2i
var color: Enums.MissileColorType
var size: Enums.MissileSizeType
var direction: Enums.Direction4Way

var amount: int

#endregion

#region Signals

signal on_amount_changed(amount: int)

#endregion
	
#region Lifecycle

func _init(p: Vector2i, c: Enums.MissileColorType, 
	s: Enums.MissileSizeType, d: Enums.Direction4Way):
	grid_pos = p
	color = c
	size = s
	direction = d

	amount = _get_init_amount(s)

#endregion

#region Methods

func get_my_sprite_path() -> String:
	return get_sprite_path(color, size)

func get_my_grid_length() -> int:
	return get_missile_grid_length(size)

func get_my_real_length() -> float:
	return get_missile_real_length(size)

func decrease_amount() -> void:
	amount -= 1
	on_amount_changed.emit(amount)

#endregion

#region Static Methods

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

static func get_missile_grid_length(missile_size: Enums.MissileSizeType) -> int:
	match missile_size:
		Enums.MissileSizeType.SMALL:
			return 2
		Enums.MissileSizeType.MEDIUM:
			return 3
		Enums.MissileSizeType.LARGE:
			return 4
		_:
			return 1

static func get_missile_real_length(missile_size: Enums.MissileSizeType) -> float:
	var grid_length := get_missile_grid_length(missile_size)
	return grid_length * Consts.MISSILE_PUZZLE_BOARD_CELL_SIZE

static func _get_init_amount(size_type: Enums.MissileSizeType) -> int:
	match size_type:
		Enums.MissileSizeType.SMALL:
			return 6
		Enums.MissileSizeType.MEDIUM:
			return 10
		Enums.MissileSizeType.LARGE:
			return 14
		_:
			return 0

#endregion
