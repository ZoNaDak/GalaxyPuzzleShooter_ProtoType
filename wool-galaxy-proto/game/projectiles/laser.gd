# laser.gd
class_name Laser

extends ProjectileBase

#region Variables

@export var raycast: RayCast2D
@export var line_renderer: Line2D

@export var move_speed: float = 10.0
@export var max_laser_level: int = 3
@export var step_up_duration: float = 1
@export var laser_widht_arr: Array[int]

var move_dir: Vector2
var collided_duration: float

var laser_level = 0

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

	collided_duration = 0.0
	laser_level = 0

	line_renderer.points = [global_position, global_position]
	line_renderer.width = laser_widht_arr[laser_level]

func _process(delta: float) -> void:
	if line_renderer.points.size() < 2:
		return
		
	line_renderer.points[1] = raycast.target_position

func _physics_process(delta: float) -> void:
	if raycast.is_colliding():
		if laser_level >= max_laser_level - 1:
			return

		collided_duration += delta
		if collided_duration >= step_up_duration * (laser_level + 1):
			laser_level += 1
			line_renderer.width = laser_widht_arr[laser_level]
	else:
		raycast.target_position += move_speed * delta * move_dir
		collided_duration = 0.0
		laser_level = 0

#endregion

#region Methods

@warning_ignore("shadowed_variable")
func set_data(character_type: Enums.CharacterType,
	start_pos: Vector2, move_dir: Vector2, damage_arr: Array[int]) -> void:
	self.character_type = character_type
	self.global_position = start_pos
	self.move_dir = move_dir
	self.damage = damage

#endregion
