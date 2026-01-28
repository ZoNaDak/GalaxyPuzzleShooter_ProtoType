# character.gd
class_name Character

extends Node2D

#region Enums

enum CharacterState {
    START_MOVE,
	IDLE,
	DYING,
	DEAD
}

#endregion

#region Variables

var data: CharacterData
var state: CharacterState

#endregion

#region Methods

func die() -> void:
	state = CharacterState.DEAD
	visible = false

#endregion