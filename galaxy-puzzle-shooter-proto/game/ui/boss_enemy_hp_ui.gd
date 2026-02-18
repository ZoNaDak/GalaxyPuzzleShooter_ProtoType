# boss_enemy_hp_ui.gd
class_name BossEnemyHpUI

extends Control

#region Variables

@export var _hp_ui: ProgressBar

var _max_hp: int
var _cur_hp: int

#endregion

#region Methods

func initialize(max_hp: int) -> void:
	_max_hp = max_hp
	_hp_ui.max_value = max_hp
	set_cur_hp(max_hp)

func set_cur_hp(hp: int) -> void:
	_cur_hp = hp
	_hp_ui.value = hp

#endregion
