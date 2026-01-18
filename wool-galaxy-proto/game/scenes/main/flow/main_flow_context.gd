# main_flow_context.gd
class_name MainFlowContext

#region Variables

var player: Player
var player_ui: PlayerUI

#endregion

#region Lifecycle

func initialize(
    player: Player,
    player_ui: PlayerUI,
) -> void:
    self.player = player
    self.player_ui = player_ui

#endregion