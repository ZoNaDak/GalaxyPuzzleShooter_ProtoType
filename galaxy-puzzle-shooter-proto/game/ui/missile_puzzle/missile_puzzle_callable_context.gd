# missile_puzzle_callable_context.gd
class_name MissilePuzzleCallableContext

#region Variables

var get_is_full_missile_slot_callable: Callable = Callable()
var reserve_missile_slot_callable: Callable = Callable()
var unreserve_missile_slot_callable: Callable = Callable()
var equip_missile_to_player_callable: Callable = Callable()

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize(
    get_is_full_missile_slot_callable: Callable,
    reserve_missile_slot_callable: Callable,
    unreserve_missile_slot_callable: Callable,
    equip_missile_to_player_callable: Callable,
) -> void:
    self.get_is_full_missile_slot_callable = get_is_full_missile_slot_callable
    self.reserve_missile_slot_callable = reserve_missile_slot_callable
    self.unreserve_missile_slot_callable = unreserve_missile_slot_callable
    self.equip_missile_to_player_callable = equip_missile_to_player_callable

#endregion