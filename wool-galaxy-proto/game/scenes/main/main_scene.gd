# main_scene.gd
class_name MainScene

extends BaseScene

#region Variables

@export var _main_flow: MainFlow

@export var _player: Player
@export var _player_ui: PlayerUI

@export var _reset_button: Button

@export var _missile_slot_board: MissileSlotBoard
@export var _missile_puzzle_board: MissilePuzzleBoard

#endregion

#region Lifecycle

func _ready() -> void:
	super._ready()
	_initialize()
	await SystemUIManager.fade_in(0.5)
	_main_flow.start_flow()

func _initialize():
	var context: MainFlowContext = MainFlowContext.new()
	context.initialize(_player, _player_ui)

	_main_flow.initialize(context)

#endregion

#region Methods

func _get_scene_state() -> GameManager.GameState:
	return GameManager.GameState.MAIN

#endregion
