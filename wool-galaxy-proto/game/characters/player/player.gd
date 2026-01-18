# player.gd
extends Node2D

class_name Player

#region Consts

const PLAYER_CONFIG: PlayerConfig = preload("res://config/resources/player_config.tres")

#endregion

#region Variables

var player_data: PlayerData

#endregion

#region Methods

func initialize():
	player_data = PlayerData.new(PLAYER_CONFIG.max_hp, PLAYER_CONFIG.max_mp)

#endregion