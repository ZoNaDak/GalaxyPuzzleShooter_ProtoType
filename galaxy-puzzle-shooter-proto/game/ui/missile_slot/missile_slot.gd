# missile_slot.gd
class_name MissileSlot

extends Control

#region Variables

@export var _missile_texture: TextureRect
@export var _missile_amount: Label

var missile_data: MissileData = null

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

func setup_missile_data(data: MissileData):
    missile_data = data
    _missile_amount.visible = true
    var sprite_path := MissileData.get_sprite_path(
        missile_data.color, Enums.MissileSizeType.MEDIUM)
    _missile_texture.texture = load(sprite_path) as Texture2D
    _missile_amount.text = str(missile_data.amount)

    data.on_amount_changed.connect(on_amount_changed)

#endregion

#region Signal Handlers

func on_amount_changed(amount: int):
    _missile_amount.text = str(amount)

#endregion
