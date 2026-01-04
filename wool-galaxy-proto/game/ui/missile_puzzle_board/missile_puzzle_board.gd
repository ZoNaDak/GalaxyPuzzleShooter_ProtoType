@tool
extends Control

#region Consts

const BASE_SIZE := Vector2(576, 384)
const GRID_WIDTH := 18
const GRID_HEIGHT := 12
const CELL_SIZE := 32

#endregion

#region Variables

@export var _layout: Control

var grid: Array[Array] = []

#endregion

#region Lifecycle

func _ready():
	if not Engine.is_editor_hint():
		resized.connect(_on_resized)
	_initialize_grid()
	_update_layout()

#endregion

#region Signal Handlers

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_update_layout()

func _on_resized():
	_update_layout()

#endregion

#region Methods

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
