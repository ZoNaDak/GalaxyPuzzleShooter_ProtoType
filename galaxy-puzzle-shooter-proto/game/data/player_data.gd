# player_data.gd
class_name PlayerData

extends CharacterData

#region Variables

var equipped_missile_datas: Array[MissileData] = []
var _reserved_missile_count := 0;
var _missile_fire_delay_arr: Array[float] = []

var max_force_shield_value: int
var cur_force_shield_value: int

#endregion

#region Signals

signal on_equip_missile(index: int, missile_data: MissileData)
signal on_unequip_missile(index: int)

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func _init(hp: int, mp: int, max_force_shield_value: int):
	super._init(hp, mp)
	self.max_force_shield_value = max_force_shield_value
	self.cur_force_shield_value = 0

	equipped_missile_datas.resize(Consts.MISSILE_SLOT_COUNT)
	for i in equipped_missile_datas.size():
		equipped_missile_datas[i] = null
	
	_missile_fire_delay_arr.resize(Consts.MISSILE_SLOT_COUNT)

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

func unreserve_missile_slot() -> void:
	_reserved_missile_count -= 1;

func equip_missile(missile_data: MissileData) -> bool:
	for i in equipped_missile_datas.size():
		if equipped_missile_datas[i] == null:
			equipped_missile_datas[i] = missile_data;
			_reserved_missile_count -= 1
			_missile_fire_delay_arr[i] = 0.0
			on_equip_missile.emit(i, missile_data)
			return true;
			
	LogManager.Error("Can't Equip Missile, Slot is Full", "PlayerData")
	return false

func unequip_missile(index: int) -> void:
	LogManager.info("Unequip Missile %d" % [index], "Player")
	equipped_missile_datas[index] = null
	_missile_fire_delay_arr[index] = 0.0
	on_unequip_missile.emit(index)

func charge_full_force_shield() -> void:
	cur_force_shield_value = max_force_shield_value

#endregion
