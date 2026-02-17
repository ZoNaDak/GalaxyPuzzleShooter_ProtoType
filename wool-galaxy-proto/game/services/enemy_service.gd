# enemy_service.gd
class_name EnemyService

extends Node

#region Consts

const ENEMY_SCENE_PATH: String = "res://game/characters/enemys/%s.tscn"
const BOSS_ENEMY_SCENE_PATH: String = "res://game/characters/boss_enemys/%s.tscn"

#endregion

#region Variables

@export var _enemy_spawn_point_arr: Array[Node2D]
@export var _boss_enemy_spawn_point: Node2D
@export var _enemy_parent: Node2D

var _enemy_arr: Array[Enemy]
var _boss_enemy: BossEnemy
var _locked_enemy: Character

#region Callable

var _enemy_callable_context: EnemyCallableContext
var _boss_enemy_callable_context: BossEnemyCallableContext

#endregion

#endregion

#region Property

var enemy_spawn_count_max: int:
	get: return _enemy_spawn_point_arr.size()

var enemy_arr: Array[Enemy]:
	get: return _enemy_arr

#endregion

#region Lifecycle

func initialize(enemy_callable_context: EnemyCallableContext,
	boss_enemy_callable_context: BossEnemyCallableContext) -> void:
	_enemy_callable_context = enemy_callable_context
	_enemy_callable_context.initialize_in_enemy_service(
		get_all_enemy_arr)
	_boss_enemy_callable_context = boss_enemy_callable_context

	for i in range(_enemy_spawn_point_arr.size()):
		_enemy_arr.append(null)
	_boss_enemy = null
	_locked_enemy = null

#endregion

#region Methods

func get_all_enemy_arr() -> Array[Enemy]:
	return _enemy_arr

func spawn_enemy(key: String, spawn_index: int) -> Enemy:
	LogManager.info("spawn_enemy : %s, %d" % [key, spawn_index], "EnemyService")
	var enemy_scene: PackedScene = load(ENEMY_SCENE_PATH % [key])
	var enemy: Enemy = enemy_scene.instantiate()
	var spawn_pos := _enemy_spawn_point_arr[spawn_index].position
	enemy.initialize(spawn_index, spawn_pos,
		_enemy_callable_context, _lock_on_enemy)
	_enemy_parent.add_child(enemy)
	_enemy_arr[spawn_index] = enemy

	if _locked_enemy == null:
		enemy.lock_on()

	return enemy

func despawn_enemy(spawn_index: int) -> void:
	if _locked_enemy == _enemy_arr[spawn_index]:
		_locked_enemy = null
		for i in _enemy_arr.size():
			if i != spawn_index and _enemy_arr[i] != null:
				_enemy_arr[i].lock_on()
				break
		
		if _locked_enemy == null and _boss_enemy != null:
			_boss_enemy.lock_on()
	
	_enemy_arr[spawn_index].queue_free()
	_enemy_arr[spawn_index] = null

func _lock_on_enemy(enemy: Character) -> void:
	if _locked_enemy == enemy:
		return

	if _locked_enemy != null:
		_locked_enemy.lock_off()

	_locked_enemy = enemy

func get_locked_enemy() -> Character:
	return _locked_enemy

func get_enemy_spawn_point_arr() -> Array[Node2D]:
	return _enemy_spawn_point_arr

func spawn_boss_enemy(key: String, boss_enemy_hp_ui: BossEnemyHpUI,
	spawn_random_enemy_callable: Callable,
	despawn_enemy_callable: Callable) -> BossEnemy:
	LogManager.info("spawn_boss_enemy : %s" % [key], "EnemyService")
	var boss_enemy_scene: PackedScene = load(BOSS_ENEMY_SCENE_PATH % [key])
	_boss_enemy = boss_enemy_scene.instantiate()
	var spawn_pos := _boss_enemy_spawn_point.position
	_boss_enemy.initialize(spawn_pos, boss_enemy_hp_ui,
		_boss_enemy_callable_context, _lock_on_enemy,
		spawn_random_enemy_callable,
		despawn_enemy_callable)
	_enemy_parent.add_child(_boss_enemy)

	if _locked_enemy == null:
		_boss_enemy.lock_on()
	return _boss_enemy

#endregion
