# player.gd
class_name Player

extends Character

#region Variables

@export var player_config: PlayerConfig
var player_data: PlayerData

#endregion

#region Lifecycle

func initialize():
	player_data = PlayerData.new(player_config.max_hp, player_config.max_mp)
	data = player_data
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

#region Methods

func _check_fire_delay(delta: float) -> void:
	for i in player_data._missile_fire_delay_arr.size():
		if player_data.equipped_missile_datas[i] == null:
			continue
		elif player_data._missile_fire_delay_arr[i] <= 0:
			_fire_missile()
			player_data._missile_fire_delay_arr[i] = player_config.missile_fire_delay
		else:
			player_data._missile_fire_delay_arr[i] -= delta

func _fire_missile() -> void:
	LogManager.info("Fire Missile", "Player")

#endregion