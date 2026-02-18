# enemy.gd
class_name Enemy

extends Character

#region Enums

enum FireType
{
	BULLET,
	LASER,
	HEAL,
}

#endregion

#region Consts

const ENEMY_SPAWN_Y_DIST: float = 100.0
const FIRST_FIRE_DELAY: float = 0.5

#endregion

#region Variables

@export var enemy_config: EnemyConfig
@export var projectile_start_point: Marker2D
@export var hp_ui: ProgressBar
@export var lock_on_ui: Node2D
@export var heal_hp_effect_pivot: Marker2D

var enemy_data: EnemyData

var spawn_index: int
var _spawn_pos: Vector2

var _cur_fire_delay: float

var _cur_laser: Laser

#region Callable

var _callable_context: EnemyCallableContext
var _lock_on_callable: Callable

#endregion

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize(spawn_index: int, spawn_pos: Vector2,
	callable_context: EnemyCallableContext,
	lock_on_callable: Callable) -> void:
	self.spawn_index = spawn_index
	_spawn_pos = spawn_pos
	self._callable_context = callable_context
	self._lock_on_callable = lock_on_callable

	position = spawn_pos + Vector2(0, -ENEMY_SPAWN_Y_DIST)
	enemy_data = EnemyData.new(enemy_config.max_hp, enemy_config.max_mp)
	data = enemy_data
	refresh_hp_ui()
	lock_on_ui.visible = false
	_cur_fire_delay = 0.0
	_cur_laser = null

	state = StateType.START_MOVE

func _process(delta: float) -> void:
	match state:
		StateType.START_MOVE:
			start_move(delta)
		StateType.IDLE:
			check_fire(delta)

func _exit_tree() -> void:
	if _cur_laser != null:
		_callable_context.despawn_projectile_callable.call(_cur_laser)
		_cur_laser = null

#endregion

#region Input

func _input(event: InputEvent) -> void:
	_check_lock_on_input(event)
	_check_debug_input(event)

func _check_lock_on_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var distance = global_position.distance_to(mouse_pos)
		if distance < 10.0:
			lock_on()

#endregion

#region Override Methods

func get_type() -> Enums.CharacterType:
	return Enums.CharacterType.ENEMY

func notify_changed_hp() -> void:
	refresh_hp_ui()

#endregion

#region Methods

func start_move(delta: float) -> void:
	var move_vector := enemy_config.move_speed * delta * Vector2.DOWN
	position += move_vector
	if position.y >= _spawn_pos.y:
		position = _spawn_pos
		_cur_fire_delay = FIRST_FIRE_DELAY
		state = StateType.IDLE

func check_fire(delta: float) -> void:
	if _cur_fire_delay <= 0.0:
		_cur_fire_delay = enemy_config.fire_delay
		_fire()
	else:
		_cur_fire_delay -= delta

func _fire() -> void:
	match enemy_config.fire_type:
		FireType.BULLET:
			var target = _callable_context.get_player_callable.call()
			var bullet: Bullet = _callable_context.spawn_bullet_callable.call("enemy_bullet_0")
			var move_dir = (target.global_position - projectile_start_point.global_position).normalized()
			bullet.set_data(get_type(), projectile_start_point.global_position,
				move_dir, enemy_config.fire_value_arr)
		FireType.LASER:
			if _cur_laser != null:
				return
			var target = _callable_context.get_player_callable.call()
			_cur_laser = _callable_context.spawn_laser_callable.call("enemy_laser_0")
			var move_dir = (target.global_position - projectile_start_point.global_position).normalized()
			_cur_laser.set_data(get_type(), projectile_start_point.global_position,
				move_dir, enemy_config.fire_value_arr)
		FireType.HEAL:
			SoundManager.play_sfx("heal")
			for enemy in _callable_context.get_all_enemy_callable.call():
				if enemy == self || enemy == null:
					continue
				enemy.do_heal_hp(enemy_config.fire_value_arr[0])
	
	LogManager.info("Fire : %s"
		% [FireType.find_key(enemy_config.fire_type)], "Enemy")

func do_heal_hp(heal_value: int) -> void:
	super.do_heal_hp(heal_value)
	_callable_context.play_effect_callable.call(
		"heal_hp_effect", heal_hp_effect_pivot.global_position)

func lock_on() -> void:
	lock_on_ui.visible = true
	_lock_on_callable.call(self)

func lock_off() -> void:
	lock_on_ui.visible = false

func refresh_hp_ui() -> void:
	hp_ui.value = float(data.cur_hp) / float(data.max_hp) * 100.0

#endregion

#region Debug
	
func _check_debug_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if state != StateType.IDLE:
		return

	if event is InputEventKey and event.keycode == KEY_2 \
		and event.is_pressed() and not event.is_echo():
		die()

#endregion
