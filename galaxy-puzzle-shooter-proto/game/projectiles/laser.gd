# laser.gd
class_name Laser

extends ProjectileBase

#region Variables

@export var raycast: RayCast2D
@export var line_renderer: Line2D

@export var move_speed: float = 10.0
@export var max_laser_level: int = 3
@export var step_up_duration: float = 1
@export var laser_width_arr: Array[int]
@export var damage_tick_time: float = 0.25

@export var damage_sfx_key: String

var move_dir: Vector2
var collided_duration: float

var laser_level = 0
var cur_damage_tick_time = 0.0

var _target: Character

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
	cur_damage_tick_time = 0.0

	line_renderer.points = [Vector2.ZERO, Vector2.ZERO]
	line_renderer.width = laser_width_arr[laser_level]

func _process(delta: float) -> void:
	if line_renderer.points.size() < 2:
		return
		
	line_renderer.points[1] = raycast.target_position

	if _target != null and is_instance_valid(_target):
		if cur_damage_tick_time >= damage_tick_time:
			cur_damage_tick_time = 0.0
			var _damage = damage_arr[laser_level]
			_target.do_damage(_damage)
			SoundManager.play_sfx(damage_sfx_key)
		else:
			cur_damage_tick_time += delta
	else:
		_target = null
			

func _physics_process(delta: float) -> void:
	if _target != null and is_instance_valid(_target):
		if laser_level >= max_laser_level - 1:
			return
		collided_duration += delta
		if collided_duration >= step_up_duration * (laser_level + 1):
			laser_level += 1
			line_renderer.width = laser_width_arr[laser_level]
	else:
		if raycast.is_colliding():
			var character = (raycast.get_collider() as Area2D).owner as Character
			if character_type != character.get_type():
				_target = character
				collided_duration = 0.0
				cur_damage_tick_time = 0.0
				laser_level = 0
		else:
			raycast.target_position += move_speed * delta * move_dir

#endregion

#region Methods

@warning_ignore("shadowed_variable")
func set_data(character_type: Enums.CharacterType,
	start_pos: Vector2, move_dir: Vector2, damage_arr: Array[int]) -> void:
	self.character_type = character_type
	self.global_position = start_pos
	self.move_dir = move_dir
	self.damage_arr = damage_arr

#endregion
