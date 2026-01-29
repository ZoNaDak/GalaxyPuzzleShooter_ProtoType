# main_flow_context.gd
class_name MainFlowContext

#region Variables

var player: Player
var player_ui: PlayerUI
var enemy_service: EnemyService
var missile_slot_board: MissileSlotBoard
var missile_puzzle_board: MissilePuzzleBoard
var game_start_text: Control
var stage_clear_text: Control
var game_over_text: Control
var stage_config: StageConfig

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize(
	player: Player,
	player_ui: PlayerUI,
	enemy_service: EnemyService,
	missile_slot_board: MissileSlotBoard,
	missile_puzzle_board: MissilePuzzleBoard,
	game_start_text: Control,
	stage_clear_text: Control,
	game_over_text: Control,
	stage_config: StageConfig) -> void:
	self.player = player
	self.player_ui = player_ui
	self.enemy_service = enemy_service
	self.missile_slot_board = missile_slot_board
	self.missile_puzzle_board = missile_puzzle_board
	self.game_start_text = game_start_text
	self.stage_clear_text = stage_clear_text
	self.game_over_text = game_over_text
	self.stage_config = stage_config

#endregion