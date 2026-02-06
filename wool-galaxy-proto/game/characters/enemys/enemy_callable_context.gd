# enemy_callable_context.gd
class_name EnemyCallableContext

#region Variables

var get_player_callable: Callable
var spawn_bullet_callable: Callable

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize(get_player_callable: Callable,
	spawn_bullet_callable: Callable) -> void:
	self.get_player_callable = get_player_callable
	self.spawn_bullet_callable = spawn_bullet_callable

#endregion
