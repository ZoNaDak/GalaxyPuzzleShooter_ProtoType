# main_flow_context.gd
class_name MainFlowContext

#region Variables

var player: Player
var player_ui: PlayerUI
var missile_slot_board: MissileSlotBoard
var missile_puzzle_board: MissilePuzzleBoard

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize(
    player: Player,
    player_ui: PlayerUI,
    missile_slot_board: MissileSlotBoard,
    missile_puzzle_board: MissilePuzzleBoard,
) -> void:
    self.player = player
    self.player_ui = player_ui
    self.missile_slot_board = missile_slot_board
    self.missile_puzzle_board = missile_puzzle_board

#endregion