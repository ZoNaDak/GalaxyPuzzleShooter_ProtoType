# boss_enemy_config.gd
class_name BossEnemyConfig

extends Resource

@export var max_hp: int = 100
@export var max_mp: int = 10
@export var move_speed: float = 100.0

@export var fire_delay: float = 2.0
# @export var fire_value_arr: Array[int] = [5]