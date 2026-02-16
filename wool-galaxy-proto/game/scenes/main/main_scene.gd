# main_scene.gd
class_name MainScene

extends BaseScene

#region Variables

@export var _main_flow: MainFlow

@export var _player: Player
@export var _player_ui: PlayerUI

@export var _enemy_service: EnemyService
@export var _projectile_service: ProjectileService
@export var _effect_service: EffectService

@export var _player_skill_button: PlayerSkillButton
@export var _reset_button: ResetButton

@export var _missile_slot_board: MissileSlotBoard
@export var _missile_puzzle_board: MissilePuzzleBoard

@export var _game_start_text: Control
@export var _stage_clear_text: Control
@export var _game_over_text: Control

@export var _stage_config: StageConfig

#endregion

#region Lifecycle

func _ready() -> void:
	super._ready()
	_initialize()
	_main_flow.start_flow()

func _initialize():
	_projectile_service.initialize()

	var enemy_callable_context := EnemyCallableContext.new()
	enemy_callable_context.initialize_in_scene(
		func(): return _player,
		_projectile_service.spawn_bullet,
		_projectile_service.spawn_laser,
		_projectile_service.despawn_projectile,
		_effect_service.play_effect
	)
	_enemy_service.initialize(enemy_callable_context)
	
	_game_start_text.visible = false
	_stage_clear_text.visible = false
	_game_over_text.visible = false

	var context: MainFlowContext = MainFlowContext.new()
	context.initialize(_player, _player_ui,
		_enemy_service, _projectile_service, _effect_service,
		_missile_slot_board, _missile_puzzle_board,
		_player_skill_button, _reset_button,
		_game_start_text, _stage_clear_text, _game_over_text,
		_stage_config)

	_main_flow.initialize(context)

#endregion

#region Methods

func _get_scene_state() -> GameManager.GameState:
	return GameManager.GameState.MAIN

#endregion
