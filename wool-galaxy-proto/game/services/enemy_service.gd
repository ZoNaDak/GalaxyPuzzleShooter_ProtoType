# enemy_service.gd
class_name EnemyService

extends Node

#region Consts

const ENEMY_SCENE_PATH: String = "res://game/characters/enemys/%s.tscn"

#endregion

#region Variables

@export var _enemy_spawn_point_arr: Array[Node2D]
@export var _enemy_parent: Node2D

var _enemy_list: Array[Enemy]

#endregion

#region Methods

func spawn_enemy(key: String, spawn_index: int) -> void:
    LogManager.info("spawn_enemy : %s, %d" % [key, spawn_index], "EnemyService")
    var enemy_scene: PackedScene = load(ENEMY_SCENE_PATH % [key])
    var enemy: Enemy = enemy_scene.instantiate()
    var spawn_pos := _enemy_spawn_point_arr[spawn_index].position
    enemy.initialize(spawn_pos)
    _enemy_parent.add_child(enemy)
    _enemy_list.append(enemy)

#endregion