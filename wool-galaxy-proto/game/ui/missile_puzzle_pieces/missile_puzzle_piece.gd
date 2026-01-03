extends Control

#region Enums

enum MissileColorType {
	RED,
	BLUE,
	GREEN,
	YELLOW,
	PURPLE,
}

enum MissileSizeType {
	SMALL,
	MEDIUM,
	LARGE,
}

#endregion

#region Consts

const SMALL_SIZE := Vector2(32, 16)
const MEDIUM_SIZE := Vector2(48, 16)
const LARGE_SIZE := Vector2(64, 16)

#endregion

#region Variables

@export var _missile_texture: TextureRect

var color_type: MissileColorType = MissileColorType.RED
var size_type: MissileSizeType = MissileSizeType.SMALL
var direction_type: Enums.Direction4Way = Enums.Direction4Way.DOWN

#endregion

#region Lifecycle

func _init(
	color: MissileColorType = color_type, 
	missile_size: MissileSizeType = size_type,
	direction: Enums.Direction4Way = direction_type):
	LogManager.warning(
		"%s, %s" % [MissileColorType.keys()[color], MissileSizeType.keys()[missile_size]], 
		"MissilePuzzlePiece")

	color_type = color
	size_type = missile_size
	direction_type = direction

func _ready():
	DebugUtils.center_if_root(self)

	_setup_size()
	_load_sprite()
	_setup_rotation()

#endregion

#region Methods

#region OnReady

func _setup_size():
	match size_type:
		MissileSizeType.SMALL:
			size = SMALL_SIZE
		MissileSizeType.MEDIUM:
			size = MEDIUM_SIZE
		MissileSizeType.LARGE:
			size = LARGE_SIZE
	pivot_offset = size / 2.0

func _load_sprite():
	var sprite_path := _get_sprite_path()
	var texture := load(sprite_path) as Texture2D
	if texture:
		_missile_texture.texture = texture
		LogManager.info("Sprite Load Success: %s" % sprite_path, "MissilePuzzlePiece")
	else:
		LogManager.error("Sprite Load Fail: %s" % sprite_path, "MissilePuzzlePiece")

func _get_sprite_path() -> String:
	return "res://game/ui/missile_puzzle_pieces/resources/%s_missile_%s.png" % [_get_color_name(), _get_size_name()]

func _get_color_name() -> String:
	match color_type:
		MissileColorType.RED:
			return "red"
		MissileColorType.BLUE:
			return "blue"
		MissileColorType.GREEN:
			return "green"
		MissileColorType.YELLOW:
			return "yellow"
		MissileColorType.PURPLE:
			return "purple"
		_:
			return "red"

func _get_size_name() -> String:
	match size_type:
		MissileSizeType.SMALL:
			return "s"
		MissileSizeType.MEDIUM:
			return "m"
		MissileSizeType.LARGE:
			return "l"
		_:
			return "m"

func _setup_rotation():
	match direction_type:
		Enums.Direction4Way.LEFT:
			rotation_degrees = 0
		Enums.Direction4Way.UP:
			rotation_degrees = 90
		Enums.Direction4Way.RIGHT:
			rotation_degrees = 180
		Enums.Direction4Way.DOWN:
			rotation_degrees = -90

#endregion

#endregion
