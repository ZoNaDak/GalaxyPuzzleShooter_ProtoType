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
@export var heal_hp_effect_pivot: Marker2D

var boss_enemy_data: BossEnemyData
var _hp_ui: BossEnemyHpUI

var _spawn_pos: Vector2

var _cur_fire_delay: float

#region Callable

var _callable_context: BossEnemyCallableContext
var _lock_on_callable: Callable

#endregion

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize(spawn_pos: Vector2,
	boss_enemy_hp_ui: BossEnemyHpUI,
	callable_context: BossEnemyCallableContext,
	lock_on_callable: Callable) -> void:
	_spawn_pos = spawn_pos
	self._hp_ui = boss_enemy_hp_ui
	self._callable_context = callable_context
	self._lock_on_callable = lock_on_callable

	position = spawn_pos + Vector2(0, -ENEMY_SPAWN_Y_DIST)
	boss_enemy_data = BossEnemyData.new(boss_enemy_config.max_hp, boss_enemy_config.max_mp)
	data = boss_enemy_data
	_hp_ui.initialize(boss_enemy_data.max_hp)
	lock_on_ui.visible = false
	_cur_fire_delay = 0.0

	state = StateType.START_MOVE

func _process(delta: float) -> void:
	match state:
		StateType.START_MOVE:
			start_move(delta)
		StateType.IDLE:
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
	if _cur_fire_delay <= 0.0:
		_cur_fire_delay = boss_enemy_config.fire_delay
		_fire()
	else:
		_cur_fire_delay -= delta

func _fire() -> void:
	LogManager.info("Fire : %s"
		% [""], "BossEnemy")

func lock_on() -> void:
	lock_on_ui.visible = true
	_lock_on_callable.call(self)

func lock_off() -> void:
	lock_on_ui.visible = false

func refresh_hp_ui() -> void:
	_hp_ui.set_cur_hp(data.cur_hp)

func die() -> void:
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