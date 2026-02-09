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

func notify_changed_hp() -> void:
	assert(false, "Must override notify_changed_hp()")

#endregion

#region Methods

func do_damage(damage: int) -> void:
	data.cur_hp -= damage
	if data.cur_hp <= 0:
		die()
	notify_changed_hp()

func _do_heal_hp(heal_value: int) -> void:
	data.cur_hp += heal_value
	if data.cur_hp > data.max_hp:
		data.cur_hp = data.max_hp
	notify_changed_hp()
	
func die() -> void:
	state = StateType.DEAD
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

#endregion