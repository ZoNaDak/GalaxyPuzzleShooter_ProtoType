# character.gd
class_name Character

extends Node2D

#region Enums

enum StateType {
    START_MOVE,
	IDLE,
	DYING,
	DEAD
}

#endregion

#region Variables

var data: CharacterData
var state: StateType

#endregion

#region Abstract Methods

func get_type() -> Enums.CharacterType:
	assert(false, "Must override get_type()")
	return Enums.CharacterType.NONE

func notify_damage() -> void:
	assert(false, "Must override notify_damage()")

#endregion

#region Methods

func do_damage(damage: int) -> void:
	data.cur_hp -= damage
	if data.cur_hp <= 0:
		die()
	else:
		notify_damage()

func die() -> void:
	state = StateType.DEAD
	visible = false

#endregion