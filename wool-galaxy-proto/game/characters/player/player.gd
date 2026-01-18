# player.gd
extends Node2D

class_name Player

#region Variables

var player_data: PlayerData

#endregion

#region Methods

func initialize():
	player_data = PlayerData.new()
	player_data.initialize()

#endregion