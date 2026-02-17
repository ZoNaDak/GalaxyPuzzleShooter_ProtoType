# boss_enemy.gd
class_name BossEnemy

extends Character

#region Consts

const ENEMY_SPAWN_Y_DIST: float = 100.0
const FIRST_FIRE_DELAY: float = 0.5

#endregion

#region Variables

@export var boss_enemy_config: BossEnemyConfig
@export var lock_on_ui: Node2D
@export var fire_0_start_point_arr: Array[Marker2D]
@export var fire_1_start_point: Marker2D
@export var heal_hp_effect_pivot: Marker2D

var boss_enemy_data: BossEnemyData
var _hp_ui: BossEnemyHpUI

var _spawn_pos: Vector2

var _cur_fire_delay: float
var _is_firing: bool

var _spawned_enemy_arr: Array[Enemy]

#region Callable

var _callable_context: BossEnemyCallableContext
var _lock_on_callable: Callable
var _spawn_random_enemy_callable: Callable
var _despawn_enemy_callable: Callable

#endregion

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize(spawn_pos: Vector2,
	boss_enemy_hp_ui: BossEnemyHpUI,
	callable_context: BossEnemyCallableContext,
	lock_on_callable: Callable,
	spawn_random_enemy_callable: Callable,
	despawn_enemy_callable: Callable) -> void:
	_spawn_pos = spawn_pos
	self._hp_ui = boss_enemy_hp_ui
	self._callable_context = callable_context
	self._lock_on_callable = lock_on_callable
	self._spawn_random_enemy_callable = spawn_random_enemy_callable
	self._despawn_enemy_callable = despawn_enemy_callable

	position = spawn_pos + Vector2(0, -ENEMY_SPAWN_Y_DIST)
	boss_enemy_data = BossEnemyData.new(boss_enemy_config.max_hp, boss_enemy_config.max_mp)
	data = boss_enemy_data
	_hp_ui.initialize(boss_enemy_data.max_hp)
	lock_on_ui.visible = false
	_cur_fire_delay = 0.0
	_is_firing = false
	_spawned_enemy_arr = []

	state = StateType.START_MOVE

func _process(delta: float) -> void:
	match state:
		StateType.START_MOVE:
			start_move(delta)
		StateType.IDLE:
			check_spawned_enemy()
			check_fire(delta)

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
	var move_vector := boss_enemy_config.move_speed * delta * Vector2.DOWN
	position += move_vector
	if position.y >= _spawn_pos.y:
		position = _spawn_pos
		_cur_fire_delay = FIRST_FIRE_DELAY
		state = StateType.IDLE

func check_fire(delta: float) -> void:
	if _is_firing:
		return
	
	if _cur_fire_delay <= 0.0:
		_cur_fire_delay = boss_enemy_config.fire_delay
		_fire()
	else:
		_cur_fire_delay -= delta

func _fire() -> void:
	var fire_type: int = -1
	if _spawned_enemy_arr.size() > 0:
		fire_type = randi() % 2
	else:
		fire_type = randi() % 3

	LogManager.info("Fire : %d" % [fire_type], "BossEnemy")
	match fire_type:
		0: _play_boss_fire_0()
		1: _play_boss_fire_1()
		2: _play_boss_fire_2()

func _play_boss_fire_0() -> void:
	_is_firing = true
	var bullet_key = "boss_enemy_bullet_0"
	var move_dir = Vector2.DOWN

	var tween = create_tween()
	for i in 2:
		tween.tween_callback(_fire_bullet.bind(
			bullet_key, fire_0_start_point_arr[i].global_position,
			move_dir, boss_enemy_config.fire0_value_arr))
	tween.tween_interval(0.5)
	for i in 2:
		tween.tween_callback(_fire_bullet.bind(
			bullet_key, fire_0_start_point_arr[i].global_position,
			move_dir, boss_enemy_config.fire0_value_arr))
	tween.tween_interval(0.5)
	for i in 2:
		tween.tween_callback(_fire_bullet.bind(
			bullet_key, fire_0_start_point_arr[i].global_position,
			move_dir, boss_enemy_config.fire0_value_arr))
	await tween.finished

	_is_firing = false

func _play_boss_fire_1() -> void:
	_is_firing = true
	var bullet_key = "boss_enemy_bullet_1"
	var move_dir = Vector2.DOWN

	var _charging_effect: GPUParticles2D = _callable_context.play_effect_callable.call(
		"charging_bullet_effect", fire_1_start_point.global_position)
	var tween = create_tween()
	tween.tween_interval(4.0)

	await tween.finished
	_callable_context.stop_effect_callable.call(_charging_effect)
	_fire_bullet(bullet_key, fire_1_start_point.global_position,
			move_dir, boss_enemy_config.fire1_value_arr)

	_is_firing = false

func _play_boss_fire_2() -> void:
	_spawn_random_enemy(0)
	_spawn_random_enemy(2)

func _fire_bullet(bullet_key: String, start_pos: Vector2,
	move_dir: Vector2, damage_arr: Array[int]) -> void:
	var bullet: Bullet = _callable_context.spawn_bullet_callable.call(bullet_key)
	bullet.set_data(get_type(), start_pos, move_dir, damage_arr)

func _spawn_random_enemy(spawn_index: int) -> void:
	var spawned_enemy = _spawn_random_enemy_callable.call(spawn_index)
	_spawned_enemy_arr.append(spawned_enemy)

func check_spawned_enemy() -> void:
	for i in range(_spawned_enemy_arr.size() - 1, -1, -1):
		var spawned_enemy = _spawned_enemy_arr[i]
		if spawned_enemy.state == Character.StateType.DEAD:
			_despawn_enemy_callable.call(spawned_enemy.spawn_index)
			_spawned_enemy_arr.remove_at(i)
			

func lock_on() -> void:
	lock_on_ui.visible = true
	_lock_on_callable.call(self)

func lock_off() -> void:
	lock_on_ui.visible = false

func refresh_hp_ui() -> void:
	_hp_ui.set_cur_hp(data.cur_hp)

func die() -> void:
	for i in _spawned_enemy_arr.size():
		var spawned_enemy = _spawned_enemy_arr[i]
		spawned_enemy.die()
		_despawn_enemy_callable.call(spawned_enemy.spawn_index)
	_spawned_enemy_arr.clear()
	super.die()

#endregion

#region Debug
	
func _check_debug_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if state != StateType.IDLE:
		return

	if event is InputEventKey and event.keycode == KEY_3 \
		and event.is_pressed() and not event.is_echo():
		die()

#endregion