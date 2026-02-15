# laser.gd
class_name Laser

extends ProjectileBase

#region Variables

@export var raycast: RayCast2D
@export var line_renderer: Line2D

@export var move_speed: float = 10.0

var move_dir: Vector2

#region Callable

var _despawn_callable: Callable

#endregion

#endregion

#region Override Methods

func get_type() -> Enums.ProjectileType:
	return Enums.ProjectileType.LASER

#endregion

#region Lifecycle

func initialize(despawn_callable: Callable) -> void:
	_despawn_callable = despawn_callable

	line_renderer.points = [global_position, global_position]

func _process(delta: float) -> void:
	if line_renderer.points.size() < 2:
		return
		
	line_renderer.points[1] = raycast.target_position

func _physics_process(delta: float) -> void:
	raycast.target_position += move_speed * delta * move_dir
	pass

#endregion

#region Methods

@warning_ignore("shadowed_variable")
func set_data(character_type: Enums.CharacterType,
	start_pos: Vector2, move_dir: Vector2, damage: int) -> void:
	self.character_type = character_type
	self.global_position = start_pos
	self.move_dir = move_dir
	self.damage = damage

#endregion
