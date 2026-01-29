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

#endregion

#region Debug

func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if event is InputEventKey and event.keycode == KEY_1 \
		and event.is_pressed() and not event.is_echo():
		die()

#endregion