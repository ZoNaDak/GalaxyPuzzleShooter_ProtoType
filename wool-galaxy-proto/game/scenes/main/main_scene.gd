# main_scene.gd
extends BaseScene

#region Signals

#endregion

#region Variables

@export var _player: Player
@export var _player_ui: PlayerUI

@export var _reset_button: Button

@export var _missile_slot_board: MissileSlotBoard
@export var _missile_puzzle_board: MissilePuzzleBoard

#endregion

#region Lifecycle

func _ready() -> void:
	super._ready()
	await SystemUIManager.fade_in(0.5)

#endregion

#region Methods

func _get_scene_state() -> GameManager.GameState:
	return GameManager.GameState.MAIN

#endregion
