# missile_slot_board.gd
extends Control

class_name MissileSlotBoard

#region Variables

@export var missile_slots: Array[MissileSlot] = []

#endregion

#region Lifecycle

func _ready():
    if DebugUtils.try_center_if_root(self):
        missile_slots[0].setup_missile_data(Enums.MissileColorType.RED, 1)
        missile_slots[1].setup_missile_data(Enums.MissileColorType.BLUE, 2)
        missile_slots[2].setup_missile_data(Enums.MissileColorType.GREEN, 3)   

#endregion

#region Methods

#endregion