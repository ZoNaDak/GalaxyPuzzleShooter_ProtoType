#player_data.gd
class_name PlayerData

#region Variables

var max_hp: int
var cur_hp: int
var max_mp: int
var cur_mp: int

var equipped_missile_datas: Array[MissileData] = []

#endregion

#region Lifecycle

func _init(hp: int, mp: int):
    max_hp = hp
    cur_hp = max_hp
    max_mp = mp
    cur_mp = max_mp

    equipped_missile_datas.resize(Consts.MISSILE_SLOT_COUNT)
    for i in equipped_missile_datas.size():
        equipped_missile_datas[i] = null

#endregion

#region Methods



#endregion