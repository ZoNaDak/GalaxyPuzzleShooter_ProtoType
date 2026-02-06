# enemy_service.gd
class_name EnemyService

extends Node

#region Consts

const ENEMY_SCENE_PATH: String = "res://game/characters/enemys/%s.tscn"

#endregion

#region Variables

@export var _enemy_spawn_point_arr: Array[Node2D]
@export var _enemy_parent: Node2D

var _enemy_arr: Array[Enemy]
var _locked_enemy: Enemy

#region Callable

var _callable_context: EnemyCallableContext

#endregion

#endregion

#region Property

var enemy_spawn_count_max: int:
	get: return _enemy_spawn_point_arr.size()

var enemy_arr: Array[Enemy]:
	get: return _enemy_arr

#endregion

#region Lifecycle

func initialize(callable_context: EnemyCallableContext) -> void:
	_callable_context = callable_context

	for i in range(_enemy_spawn_point_arr.size()):
		_enemy_arr.append(null)
	_locked_enemy = null

#endregion

#region Methods

func spawn_enemy(key: String, spawn_index: int) -> void:
	LogManager.info("spawn_enemy : %s, %d" % [key, spawn_index], "EnemyService")
	var enemy_scene: PackedScene = load(ENEMY_SCENE_PATH % [key])
	var enemy: Enemy = enemy_scene.instantiate()
	var spawn_pos := _enemy_spawn_point_arr[spawn_index].position
	enemy.initialize(spawn_index, spawn_pos,
		_callable_context, _lock_on_enemy)
	_enemy_parent.add_child(enemy)
	_enemy_arr[spawn_index] = enemy

	if _locked_enemy == null:
		enemy.lock_on()

func despawn_enemy(spawn_index: int) -> void:
	if _locked_enemy == _enemy_arr[spawn_index]:
		for i in _enemy_arr.size():
			if i != spawn_index and _enemy_arr[i] != null:
				_enemy_arr[i].lock_on()
				break
	
	_enemy_arr[spawn_index].queue_free()
	_enemy_arr[spawn_index] = null

func _lock_on_enemy(enemy: Enemy) -> void:
	if _locked_enemy == enemy:
		return

	if _locked_enemy != null:
		_locked_enemy.lock_off()

	_locked_enemy = enemy

func get_locked_enemy() -> Enemy:
	return _locked_enemy

#endregion