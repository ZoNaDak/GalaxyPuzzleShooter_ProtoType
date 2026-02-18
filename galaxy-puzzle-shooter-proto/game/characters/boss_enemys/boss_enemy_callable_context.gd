# boss_enemy_callable_context.gd
class_name BossEnemyCallableContext

#region Variables

var get_player_callable: Callable
var spawn_bullet_callable: Callable
var play_effect_callable: Callable
var stop_effect_callable: Callable

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize_in_scene(
	get_player_callable: Callable,
	spawn_bullet_callable: Callable,
	play_effect_callable: Callable,
	stop_effect_callable: Callable) -> void:
	self.get_player_callable = get_player_callable
	self.spawn_bullet_callable = spawn_bullet_callable
	self.play_effect_callable = play_effect_callable
	self.stop_effect_callable = stop_effect_callable

#endregion
