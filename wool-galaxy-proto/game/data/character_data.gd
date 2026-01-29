#character_data.gd
class_name CharacterData

#region Variables

var max_hp: int
var cur_hp: int
var max_mp: int
var cur_mp: int

#endregion

#region Lifecycle

func _init(hp: int, mp: int):
	max_hp = hp
	cur_hp = max_hp
	max_mp = mp
	cur_mp = max_mp

#endregion