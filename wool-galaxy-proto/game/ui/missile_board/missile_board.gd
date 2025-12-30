@tool
extends Control

const BASE_SIZE := Vector2(576, 384)

func _ready():
	if not Engine.is_editor_hint():
		resized.connect(_on_resized)
	_update_layout()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_update_layout()

func _on_resized():
	_update_layout()

func _update_layout():
	if get_child_count() == 0:
		return
	
	var child = get_child(0)
	if not child:
		return
	
	# 크기가 0이면 아직 레이아웃이 안된 것
	if size.x <= 0 or size.y <= 0:
		return
	
	# 스케일 계산
	var scale_factor = min(size.x / BASE_SIZE.x, size.y / BASE_SIZE.y)
	child.scale = Vector2(scale_factor, scale_factor)
	
	# 하단 중앙 정렬
	var scaled_size = BASE_SIZE * scale_factor
	child.position.x = (size.x - scaled_size.x) / 2
	child.position.y = size.y - scaled_size.y
