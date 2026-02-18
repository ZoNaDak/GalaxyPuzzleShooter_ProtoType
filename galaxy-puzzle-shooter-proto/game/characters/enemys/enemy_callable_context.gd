# enemy_callable_context.gd
class_name EnemyCallableContext

#region Variables

var get_player_callable: Callable
var get_all_enemy_callable: Callable
var get_boss_enemy_callable: Callable
var spawn_bullet_callable: Callable
var spawn_laser_callable: Callable
var despawn_projectile_callable: Callable
var play_effect_callable: Callable

#endregion

#region Lifecycle

@warning_ignore("shadowed_variable")
func initialize_in_scene(get_player_callable: Callable,
	spawn_bullet_callable: Callable,
	spawn_laser_callable: Callable,
	despawn_projectile_callable: Callable,
	play_effect_callable: Callable) -> void:
	self.get_player_callable = get_player_callable
	self.spawn_bullet_callable = spawn_bullet_callable
	self.spawn_laser_callable = spawn_laser_callable
	self.despawn_projectile_callable = despawn_projectile_callable
	self.play_effect_callable = play_effect_callable

@warning_ignore("shadowed_variable")
func initialize_in_enemy_service(
	get_all_enemy_callable: Callable,
	get_boss_enemy_callable: Callable) -> void:
	self.get_all_enemy_callable = get_all_enemy_callable
	self.get_boss_enemy_callable = get_boss_enemy_callable

#endregion
