# player_config.gd
class_name PlayerConfig

extends Resource

@export var max_hp: int = 100
@export var max_mp: int = 10
@export var max_force_shield_value: int = 10

@export var missile_fire_delay: float = 0.5

@export var red_missile_value: int = 6
@export var blue_missile_value: int = 10
@export var green_missile_value: int = 5
@export var yellow_missile_value: int = 3