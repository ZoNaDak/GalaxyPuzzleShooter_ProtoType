# player_ui.gd
class_name PlayerUI

extends Control

#region Variables

@export var _player_hp_UI: ProgressBar
@export var _player_hp_label: Label

@export var _player_mp_UI: ProgressBar
@export var _player_mp_label: Label

var cur_hp: int
var max_hp: int

var cur_mp: int
var max_mp: int

#endregion

#region Methods

func initialize(data: PlayerData):
	max_hp = data.max_hp
	_player_hp_UI.max_value = data.max_hp
	set_cur_hp(max_hp)

	max_mp = data.max_mp
	_player_mp_UI.max_value = data.max_mp
	set_cur_mp(max_mp)

func set_cur_hp(hp: int):
	cur_hp = hp
	_player_hp_UI.value = hp
	_player_hp_label.text = "%d / %d" % [cur_hp, max_hp]

func set_cur_mp(mp: int):
	cur_mp = mp
	_player_mp_UI.value = mp
	_player_mp_label.text = "%d / %d" % [cur_mp, max_mp]

#endregion
