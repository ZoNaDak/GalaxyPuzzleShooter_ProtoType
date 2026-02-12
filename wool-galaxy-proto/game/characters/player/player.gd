# player.gd
class_name Player

extends Character

#region Variables

@export var player_config: PlayerConfig
@export var projectile_start_point: Marker2D
@export var heal_effect_pivot: Marker2D
@export var force_shield_effect: Node2D
@export var force_shield_ui: ProgressBar

var player_data: PlayerData

var _player_skill_button: PlayerSkillButton
var _cur_player_skill_cooltime: float

var _is_on_skill: bool

#region Callable

var _callable_context: PlayerCallableContext

#endregion

#endregion

#region Lifecycle

func initialize(player_skill_button: PlayerSkillButton,
	callable_context: PlayerCallableContext) -> void:
	player_data = PlayerData.new(
		player_config.max_hp, player_config.max_mp, player_config.max_force_shield_value)
	data = player_data

	_is_on_skill = false

	if player_skill_button != null:
		_player_skill_button = player_skill_button
		_player_skill_button.set_on_pressed_callable(do_player_skill)
		refresh_player_skill_cooltime_ui()

	_callable_context = callable_context

	force_shield_effect.visible = false
	force_shield_ui.visible = false

	state = StateType.IDLE

func _process(delta: float) -> void:
	_check_fire_delay(delta)
	_check_player_skill_cooltime(delta)

#endregion

#region Debug

func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if event is InputEventKey and event.keycode == KEY_1 \
		and event.is_pressed() and not event.is_echo():
		die()

#endregion

#region Override Methods

func get_type() -> Enums.CharacterType:
	return Enums.CharacterType.PLAYER

func notify_changed_hp() -> void:
	_callable_context.notify_changed_hp.call(data.cur_hp)

func notify_changed_mp() -> void:
	_callable_context.notify_changed_mp.call(data.cur_mp)

func do_damage(damage: int) -> void:
	if (player_data.cur_force_shield_value > 0):
		player_data.cur_force_shield_value -= damage
		refresh_force_shield_ui()
		if player_data.cur_force_shield_value <= 0:
			player_data.cur_force_shield_value = 0
			force_shield_effect.visible = false
			force_shield_ui.visible = false
			_is_on_skill = false
	else:
		super.do_damage(damage)

#endregion

#region Methods

#region Process Methods

func _check_fire_delay(delta: float) -> void:
	for i in player_data._missile_fire_delay_arr.size():
		if player_data.equipped_missile_datas[i] == null:
			continue
		elif player_data._missile_fire_delay_arr[i] <= 0:
			var target = _callable_context.get_locked_enemy_callable.call()
			if target == null:
				continue
				
			_fire_missile(i, player_data.equipped_missile_datas[i])
			player_data._missile_fire_delay_arr[i] = player_config.missile_fire_delay
		else:
			player_data._missile_fire_delay_arr[i] -= delta

func _check_player_skill_cooltime(delta: float) -> void:
	if _cur_player_skill_cooltime > 0:
		_cur_player_skill_cooltime -= delta
		refresh_player_skill_cooltime_ui()
	
#endregion
func _fire_missile(missile_index: int, missile_data: MissileData) -> void:
	LogManager.info("Fire Missile : %s"
		% [Enums.MissileColorType.find_key(missile_data.color)], "Player")

	var target = _callable_context.get_locked_enemy_callable.call()
	match missile_data.color:
		Enums.MissileColorType.RED:
			var bullet: Bullet = _callable_context.spawn_bullet_callable.call("player_bullet_m")
			var move_dir = (target.global_position - projectile_start_point.global_position).normalized()
			bullet.set_data(get_type(), projectile_start_point.global_position,
				move_dir, player_config.red_missile_value)
		Enums.MissileColorType.BLUE:
			pass
		Enums.MissileColorType.GREEN:
			do_heal_hp(player_config.green_missile_value)
		Enums.MissileColorType.YELLOW:
			var enemy_spawn_point_arr = _callable_context.get_enemy_spawn_point_arr_callable.call()
			for i in enemy_spawn_point_arr.size():
				var bullet: Bullet = _callable_context.spawn_bullet_callable.call("player_bullet_s")
				var move_dir = (enemy_spawn_point_arr[i].global_position - projectile_start_point.global_position).normalized()
				bullet.set_data(get_type(), projectile_start_point.global_position,
					move_dir, player_config.yellow_missile_value)

	missile_data.decrease_amount()
	if (missile_data.amount == 0):
		player_data.unequip_missile(missile_index)

func do_heal_hp(heal_value: int) -> void:
	super.do_heal_hp(heal_value)
	_callable_context.play_effect_callable.call(
		"heal_effect", heal_effect_pivot.global_position)

func do_player_skill() -> void:
	LogManager.info("Do Player Skill", "Player")
	if _cur_player_skill_cooltime > 0 \
		or player_data.cur_mp < player_config.player_skill_mp_cost:
		return

	_is_on_skill = true
	player_data.charge_full_force_shield()
	force_shield_effect.visible = true
	force_shield_ui.visible = true
	refresh_force_shield_ui()
	
	player_data.cur_mp -= player_config.player_skill_mp_cost
	notify_changed_mp()

	_cur_player_skill_cooltime = player_config.player_skill_cooltime
	refresh_player_skill_cooltime_ui()

func refresh_player_skill_cooltime_ui() -> void:
	_player_skill_button.set_cooltime_value(
		_cur_player_skill_cooltime / player_config.player_skill_cooltime)

func refresh_force_shield_ui() -> void:
	var ratio = float(player_data.cur_force_shield_value) / float(player_data.max_force_shield_value) * 100.0
	force_shield_ui.value = ratio

#endregion
