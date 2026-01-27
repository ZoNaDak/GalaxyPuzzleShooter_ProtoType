# stage_config.gd
class_name StageConfig

extends Resource

@export var enemy_spawn_total_count: int = 10
@export var enemy_spawn_delay_min_max: Vector2 = Vector2(0.25, 1.0)