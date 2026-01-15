# missile_slot.gd
extends Control

class_name MissileSlot

#region Variables

@export var _missile_texture: TextureRect
@export var _missile_amount: Label

#endregion

#region Lifecycle

func _ready():
    if DebugUtils.try_center_if_root(self):
        setup_empty()

#endregion

#region Methods

func setup_empty():
    _missile_texture.texture = null
    _missile_amount.visible = false

func setup_missile_data(color: Enums.MissileColorType, amount: int):
    _missile_amount.visible = true
    var sprite_path := MissileData.get_sprite_path(color, Enums.MissileSizeType.MEDIUM)
    _missile_texture.texture = load(sprite_path) as Texture2D
    _missile_amount.text = str(amount)

#endregion