# missile_slot_board.gd
class_name MissileSlotBoard

extends Control

#region Variables

@export var _missile_slots: Array[MissileSlot] = []

#endregion

#region Lifecycle

func _ready():
	if DebugUtils.try_center_if_root(self):
		initialize()

func initialize():
	for missile_slot in _missile_slots:
		missile_slot.setup_empty()

#endregion

#region Methods

#endregion

#region Signal Handlers

func on_equip_missile(index: int, missile_data: MissileData):
	_missile_slots[index].setup_missile_data(missile_data)

func on_unequip_missile(index: int):
	_missile_slots[index].setup_empty()

#endregion
