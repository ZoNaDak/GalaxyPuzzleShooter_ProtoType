# bullet.gd
class_name Bullet

extends ProjectileBase

#region Variables

var character_type: Enums.CharacterType
var move_dir: Vector2

#endregion

#region Override Methods

func get_type() -> Enums.ProjectileType:
	return Enums.ProjectileType.BULLET

#endregion

#region Methods

@warning_ignore("shadowed_variable")
func initialize(character_type: Enums.CharacterType,
	start_pos: Vector2, move_dir: Vector2) -> void:
	self.character_type = character_type
	self.position = start_pos
	self.move_dir = move_dir

#endregion
