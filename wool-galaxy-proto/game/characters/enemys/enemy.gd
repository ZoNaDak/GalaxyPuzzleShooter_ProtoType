# enemy.gd
class_name Enemy

extends Character

#region Enums

enum EnemyState 
{
    START_MOVE,
    IDLE,
}

#endregion

#region Consts

const ENEMY_SPAWN_Y_DIST: float = 100.0

#endregion

#region Variables

@export var enemy_config: EnemyConfig

var enemy_data: EnemyData
var state: EnemyState

var _spawn_pos: Vector2

#endregion

#region Lifecycle

func initialize(spawn_pos: Vector2) -> void:
    _spawn_pos = spawn_pos
    position = spawn_pos + Vector2(0, -ENEMY_SPAWN_Y_DIST)
    enemy_data = EnemyData.new(enemy_config.max_hp, enemy_config.max_mp)
    data = enemy_data
    state = EnemyState.START_MOVE

func _process(delta: float) -> void:
    match state:
        EnemyState.START_MOVE:
            start_move(delta)
        EnemyState.IDLE:
            pass

#endregion

#region Methods

func start_move(delta: float) -> void:
    var move_vector := enemy_config.move_speed * delta * Vector2.DOWN
    position += move_vector
    if position.y >= _spawn_pos.y:
        position = _spawn_pos
        state = EnemyState.IDLE

#endregion
