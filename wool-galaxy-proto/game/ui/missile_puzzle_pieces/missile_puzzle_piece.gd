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

var _color_type: MissileColorType = MissileColorType.RED
var _size_type: MissileSizeType = MissileSizeType.SMALL

#endregion

#region Lifecycle

func _init(
	color_type: MissileColorType = _color_type, 
	size_type: MissileSizeType = _size_type):
	LogManager.warning(
		"%s, %s" % [MissileColorType.keys()[color_type], MissileSizeType.keys()[size_type]], 
		"MissilePuzzlePiece")

	_color_type = color_type
	_size_type = size_type

func _ready():
	_update_size()
	_load_sprite()

#endregion

#region Methods

#region OnReady

func _update_size():
	match _size_type:
		MissileSizeType.SMALL:
			size = SMALL_SIZE
		MissileSizeType.MEDIUM:
			size = MEDIUM_SIZE
		MissileSizeType.LARGE:
			size = LARGE_SIZE

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
	match _color_type:
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
	match _size_type:
		MissileSizeType.SMALL:
			return "s"
		MissileSizeType.MEDIUM:
			return "m"
		MissileSizeType.LARGE:
			return "l"
		_:
			return "m"

#endregion

#endregion
