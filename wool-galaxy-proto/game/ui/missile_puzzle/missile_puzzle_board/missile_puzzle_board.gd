@tool
extends Control

class_name MissilePuzzleBoard

#region Consts

const BASE_SIZE := Vector2(576, 384)
const GRID_WIDTH := Consts.MISSILE_PUZZLE_BOARD_GRID_WIDTH
const GRID_HEIGHT := Consts.MISSILE_PUZZLE_BOARD_GRID_HEIGHT

const MissilePuzzlePieceScene = preload("res://game/ui/missile_puzzle/missile_puzzle_pieces/missile_puzzle_piece.tscn")

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
	var _temp_grid: Array[Array] = []
	for y in range(GRID_HEIGHT):
		var row: Array = []
		row.resize(GRID_WIDTH)
		for x in range(GRID_WIDTH):
			row[x] = null
		_temp_grid.append(row)
	var _temp_missile_data_arr: Array[MissileData] = []

	if _fill_board_randomly(_temp_grid, _temp_missile_data_arr):
		LogManager.info("Board Fill Completed! Missile Num: %d" % _temp_missile_data_arr.size(), "MissilePuzzleBoard")
		for data in _temp_missile_data_arr:
			_spawn_missile_piece(data)
	else:
		LogManager.error("Board Fill Failed!", "MissilePuzzleBoard")

func _fill_board_randomly(temp_grid: Array[Array], temp_missile_data_arr: Array[MissileData]) -> bool:
	var empty_cell := _find_first_empty_cell(temp_grid)
	
	if empty_cell == Vector2i(-1, -1):
		return true
	
	var combinations := _get_shuffled_missile_combinations()
	
	for combo in combinations:
		var color: Enums.MissileColorType = combo["color"]
		var missile_size: Enums.MissileSizeType = combo["size"]
		var direction: Enums.Direction4Way = combo["direction"]
		
		if _can_place_missile(temp_grid, empty_cell, missile_size, direction):
			# Add Missile Data
			var data := MissileData.new(empty_cell, color, missile_size, direction)
			temp_missile_data_arr.append(data)

			var cells := MissilePuzzlePiece.get_grid_cells(
				Vector2i(GRID_WIDTH, GRID_HEIGHT), empty_cell, missile_size, direction)
			for cell in cells:
				temp_grid[cell.y][cell.x] = data
			
			# Check Board is filled
			if _fill_board_randomly(temp_grid, temp_missile_data_arr):
				return true
			
			# Remove Missile Data
			for cell in cells:
				temp_grid[cell.y][cell.x] = null
	
			temp_missile_data_arr.erase(data)
	
	return false

func _find_first_empty_cell(temp_grid: Array[Array]) -> Vector2i:
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if temp_grid[y][x] == null:
				return Vector2i(x, y)
	return Vector2i(-1, -1)

func _get_shuffled_missile_combinations() -> Array[Dictionary]:
	var combinations: Array[Dictionary] = []
	
	for color in Enums.MissileColorType.values():
		for missile_size in Enums.MissileSizeType.values():
			for direction in Enums.Direction4Way.values():
				combinations.append({
					"color": color,
					"size": missile_size,
					"direction": direction
				})
	
	combinations.shuffle()
	return combinations

func _can_place_missile(
	temp_grid: Array[Array], grid_pos: Vector2i, 
	missile_size: Enums.MissileSizeType, direction: Enums.Direction4Way) -> bool:
	
	var cells := MissilePuzzlePiece.get_grid_cells(
		Vector2i(GRID_WIDTH, GRID_HEIGHT), grid_pos, missile_size, direction)
	
	for cell in cells:
		if cell.x < 0 or cell.x >= GRID_WIDTH or cell.y < 0 or cell.y >= GRID_HEIGHT:
			return false
		if temp_grid[cell.y][cell.x] != null:
			return false
	
	return true

func _spawn_missile_piece(missile_data: MissileData):
	var missile = MissilePuzzlePieceScene.instantiate()
	missile.name = "Missile_%s_%s" % [missile_data.grid_pos, missile.get_instance_id()]
	_missile_parent.add_child(missile)

	missile.initialize(missile_data)

	for cell in missile.get_my_grid_cells():
		grid[cell.y][cell.x] = missile.get_instance_id()

	missiles.append(missile)

#endregion

#endregion
