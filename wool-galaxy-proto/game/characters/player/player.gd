# player.gd
class_name Player

extends Character

#region Consts

const PLAYER_CONFIG: PlayerConfig = preload("res://config/resources/player_config.tres")

#endregion

#region Variables

var player_data: PlayerData

#endregion

#region Lifecycle

func initialize():
	player_data = PlayerData.new(PLAYER_CONFIG.max_hp, PLAYER_CONFIG.max_mp)
	data = player_data

#endregion