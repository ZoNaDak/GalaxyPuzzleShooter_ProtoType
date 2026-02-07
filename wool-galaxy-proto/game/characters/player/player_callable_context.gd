# player_callable_context.gd
class_name PlayerCallableContext

#region Variables

var spawn_bullet_callable: Callable
var get_locked_enemy_callable: Callable
var get_enemy_spawn_point_arr_callable: Callable
var notify_changed_hp: Callable
var notify_changed_mp: Callable

#endregion

#region Methods

@warning_ignore("shadowed_variable")
func initialize(spawn_bullet_callable: Callable,
	get_enemy_spawn_point_arr_callable: Callable,
	get_locked_enemy_callable: Callable,
	notify_changed_hp: Callable,
	notify_changed_mp: Callable
) -> void:
	self.spawn_bullet_callable = spawn_bullet_callable
	self.get_enemy_spawn_point_arr_callable = get_enemy_spawn_point_arr_callable
	self.get_locked_enemy_callable = get_locked_enemy_callable
	self.notify_changed_hp = notify_changed_hp
	self.notify_changed_mp = notify_changed_mp

#endregion
