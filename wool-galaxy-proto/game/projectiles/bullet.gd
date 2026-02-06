# bullet.gd
class_name Bullet

extends ProjectileBase

#region Variables

@export var area: Area2D
@export var move_speed: float = 10.0

var character_type: Enums.CharacterType
var move_dir: Vector2
var damage: int

#region Callable

var _despawn_callable: Callable

#endregion

#endregion

#region Override Methods

func get_type() -> Enums.ProjectileType:
	return Enums.ProjectileType.BULLET

#endregion

#region Methods

func initialize(despawn_callable: Callable) -> void:
	area.monitoring = true
	_despawn_callable = despawn_callable

func _process(delta: float) -> void:
	_check_out_of_screen()
	position += move_speed * delta * move_dir

#endregion

#region Methods

@warning_ignore("shadowed_variable")
func set_data(character_type: Enums.CharacterType,
	start_pos: Vector2, move_dir: Vector2, damage: int) -> void:
	self.character_type = character_type
	self.global_position = start_pos
	self.move_dir = move_dir
	self.damage = damage

func _check_out_of_screen() -> void:
	if global_position.x < 0 or global_position.x > get_viewport().size.x \
		or global_position.y < 0 or global_position.y > get_viewport().size.y:
		_despawn_callable.call(self)

#endregion

#region Collision

func _on_area_entered(other_area: Area2D) -> void:
	var character = other_area.owner as Character
	character.do_damage(damage)
	area.monitoring = false
	_despawn_callable.call(self)

#endregion
