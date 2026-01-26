# character.gd
class_name Character

extends Node2D

#region Variables

var data: CharacterData

#endregion

#region Lifecycle

func initialize() -> void:
    push_error("Must override initialize()")

#endregion