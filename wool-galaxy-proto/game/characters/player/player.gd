# player.gd
class_name Player

extends Character

#region Variables

@export var player_config: PlayerConfig
@export var projectile_start_point: Marker2D
@export var heal_effect_pivot: Marker2D

var player_data: PlayerData

#region Callable

var _callable_context: PlayerCallableContext

#endregion

#endregion

#region Lifecycle

func initialize(callable_context: PlayerCallableContext) -> void:
	player_data = PlayerData.new(player_config.max_hp, player_config.max_mp)
	data = player_data

	_callable_context = callable_context

	state = StateType.IDLE

func _process(delta: float) -> void:
	_check_fire_delay(delta)

#endregion

#region Debug

func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if event is InputEventKey and event.keycode == KEY_1 \
		and event.is_pressed() and not event.is_echo():
		die()
	
	if event is InputEventKey and event.keycode == KEY_3 \
		and event.is_pressed() and not event.is_echo():
		_heal_hp()

#endregion

#region Override Methods

func get_type() -> Enums.CharacterType:
	return Enums.CharacterType.PLAYER

func notify_damage() -> void:
	_callable_context.notify_changed_hp.call(data.cur_hp)

#endregion

#region Methods

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
			pass
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

func _heal_hp() -> void:
	_callable_context.play_effect_callable.call(
		"heal_effect", heal_effect_pivot.global_position)

#endregion
