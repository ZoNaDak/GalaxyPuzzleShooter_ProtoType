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

#endregion

#region Property

var enemy_spawn_count_max: int:
	get: return _enemy_spawn_point_arr.size()

var enemy_arr: Array[Enemy]:
	get: return _enemy_arr

#endregion

#region Lifecycle

func initialize() -> void:
	for i in range(_enemy_spawn_point_arr.size()):
		_enemy_arr.append(null)

#endregion

#region Methods

func spawn_enemy(key: String, spawn_index: int) -> void:
	LogManager.info("spawn_enemy : %s, %d" % [key, spawn_index], "EnemyService")
	var enemy_scene: PackedScene = load(ENEMY_SCENE_PATH % [key])
	var enemy: Enemy = enemy_scene.instantiate()
	var spawn_pos := _enemy_spawn_point_arr[spawn_index].position
	enemy.initialize(spawn_index, spawn_pos)
	_enemy_parent.add_child(enemy)
	_enemy_arr[spawn_index] = enemy

func despawn_enemy(spawn_index: int) -> void:
	_enemy_arr[spawn_index].queue_free()
	_enemy_arr[spawn_index] = null

#endregion