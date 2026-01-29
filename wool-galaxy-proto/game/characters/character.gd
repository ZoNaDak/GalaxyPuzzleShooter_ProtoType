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

#region Methods

func die() -> void:
	state = StateType.DEAD
	visible = false

#endregion