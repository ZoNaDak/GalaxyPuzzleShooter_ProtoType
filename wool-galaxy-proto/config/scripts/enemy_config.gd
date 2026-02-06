# enemy_config.gd
class_name EnemyConfig

extends Resource

@export var max_hp: int = 100
@export var max_mp: int = 10
@export var move_speed: float = 100.0

@export var fire_type: Enemy.FireType = Enemy.FireType.BULLET
@export var fire_delay: float = 2.0
@export var fire_value: int = 5