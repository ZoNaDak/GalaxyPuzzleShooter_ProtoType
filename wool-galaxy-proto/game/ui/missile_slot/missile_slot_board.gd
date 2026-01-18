# missile_slot_board.gd
extends Control

class_name MissileSlotBoard

#region Variables

@export var _missile_slots: Array[MissileSlot] = []

#endregion

#region Lifecycle

func _ready():
	if DebugUtils.try_center_if_root(self):
		initialize()

func initialize():
	_missile_slots[0].setup_empty()
	_missile_slots[1].setup_empty()
	_missile_slots[2].setup_empty()

#endregion

#region Methods

#endregion
