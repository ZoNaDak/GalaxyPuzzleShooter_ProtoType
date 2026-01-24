#player_data.gd
class_name PlayerData

#region Variables

var max_hp: int
var cur_hp: int
var max_mp: int
var cur_mp: int

var equipped_missile_datas: Array[MissileData] = []
var _reserved_missile_count := 0;

#endregion

#region Signals

signal on_equip_missile(index: int, missile_data: MissileData)

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

func get_is_full_missile_slot() -> bool:
    var remain_slot_count := Consts.MISSILE_SLOT_COUNT
    for missile_data in equipped_missile_datas:
        if missile_data != null:
            remain_slot_count -= 1;
    
    var result := remain_slot_count - _reserved_missile_count <= 0;
    return result;

func reserve_missile_slot() -> void:
    _reserved_missile_count += 1;

func equip_missile(missile_data: MissileData) -> bool:
    for i in equipped_missile_datas.size():
        if equipped_missile_datas[i] == null:
            equipped_missile_datas[i] = missile_data;
            _reserved_missile_count -= 1
            on_equip_missile.emit(i, missile_data)
            return true;
            
    LogManager.Error("Can't Equip Missile, Slot is Full", "PlayerData")
    return false

#endregion