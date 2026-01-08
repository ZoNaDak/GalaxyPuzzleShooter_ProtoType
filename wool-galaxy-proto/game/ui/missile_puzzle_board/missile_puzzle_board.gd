@tool
extends Control

class_name MissilePuzzleBoard

#region Consts

const BASE_SIZE := Vector2(576, 384)
const GRID_WIDTH := 18
const GRID_HEIGHT := 12
const CELL_SIZE := 32

const MissilePuzzlePieceScene = preload("res://game/ui/missile_puzzle_pieces/missile_puzzle_piece.tscn")

#endregion

#region Variables

@export var _layout: Control
@export var _missile_parent: Control

var grid: Array[Array] = []
var missiles: Array[MissilePuzzlePiece] = []

#endregion

#region Lifecycle

func _ready():
	if not Engine.is_editor_hint():
		resized.connect(_on_resized)
		
	_initialize_grid()
	_update_layout()

	if not Engine.is_editor_hint():
		_setup_missile_puzzle_board()

#endregion

#region Signal Handlers

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_update_layout()

func _on_resized():
	_update_layout()

#endregion

#region Methods

#region OnReady

func _initialize_grid():
	grid.clear()
	for y in range(GRID_HEIGHT):
		var row: Array = []
		row.resize(GRID_WIDTH)
		for x in range(GRID_WIDTH):
			row[x] = null
		grid.append(row)

func _update_layout():
	# 크기가 0이면 아직 레이아웃이 안된 것
	if size.x <= 0 or size.y <= 0:
		return
	
	# 스케일 계산
	var scale_factor = min(size.x / BASE_SIZE.x, size.y / BASE_SIZE.y)
	_layout.scale = Vector2(scale_factor, scale_factor)
	
	# 중앙 정렬
	var scaled_size = BASE_SIZE * scale_factor
	_layout.position.x = (size.x - scaled_size.x) / 2
	_layout.position.y = (size.y - scaled_size.y) / 2

#endregion

#region Setup Missile Puzzle Board

func _setup_missile_puzzle_board():
	_spawn_missile_piece(0, 0, 
		MissilePuzzlePiece.MissileColorType.RED, 
		MissilePuzzlePiece.MissileSizeType.SMALL, 
		Enums.Direction4Way.DOWN)
	_spawn_missile_piece(1, 0, 
		MissilePuzzlePiece.MissileColorType.BLUE, 
		MissilePuzzlePiece.MissileSizeType.MEDIUM, 
		Enums.Direction4Way.DOWN)
	_spawn_missile_piece(2, 0, 
		MissilePuzzlePiece.MissileColorType.GREEN, 
		MissilePuzzlePiece.MissileSizeType.LARGE, 
		Enums.Direction4Way.DOWN)

func _spawn_missile_piece(grid_x: int, grid_y: int, 
	color_type: MissilePuzzlePiece.MissileColorType, 
	size_type: MissilePuzzlePiece.MissileSizeType, 
	direction: Enums.Direction4Way):
		
	var missile = MissilePuzzlePieceScene.instantiate()
	missile.name = "Missile_%s" % [missiles.size()]
	missile.initialize(color_type, size_type, direction)
	_missile_parent.add_child(missile)
	missile.set_grid_pos(grid_x, grid_y)
	missiles.append(missile)

#endregion

#endregion
