# player.gd
class_name Player

extends Character

#region Variables

@export var player_config: PlayerConfig
var player_data: PlayerData

#region Callable

var _fire_projectile_callable: Callable

#endregion

#endregion

#region Lifecycle

func initialize(fire_projectile_callable: Callable) -> void:
	player_data = PlayerData.new(player_config.max_hp, player_config.max_mp)
	data = player_data

	_fire_projectile_callable = fire_projectile_callable

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

#endregion

#region Override Methods

func get_type() -> Enums.CharacterType:
	return Enums.CharacterType.PLAYER

#endregion

#region Methods

func _check_fire_delay(delta: float) -> void:
	for i in player_data._missile_fire_delay_arr.size():
		if player_data.equipped_missile_datas[i] == null:
			continue
		elif player_data._missile_fire_delay_arr[i] <= 0:
			_fire_missile(i, player_data.equipped_missile_datas[i])
			player_data._missile_fire_delay_arr[i] = player_config.missile_fire_delay
		else:
			player_data._missile_fire_delay_arr[i] -= delta

func _fire_missile(missile_index: int, missile_data: MissileData) -> void:
	LogManager.info("Fire Missile : %s"
		% [Enums.MissileColorType.find_key(missile_data.color)], "Player")

	match missile_data.color:
		Enums.MissileColorType.RED:
			var bullet: Bullet = _fire_projectile_callable.call("player_bullet")
			bullet.initialize(get_type(), position, Vector2.UP)
		Enums.MissileColorType.BLUE:
			pass
		Enums.MissileColorType.GREEN:
			pass
		Enums.MissileColorType.YELLOW:
			pass
		Enums.MissileColorType.PURPLE:
			pass

	missile_data.decrease_amount()
	if (missile_data.amount == 0):
		player_data.unequip_missile(missile_index)

#endregion