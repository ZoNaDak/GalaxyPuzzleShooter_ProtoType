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

#endregion