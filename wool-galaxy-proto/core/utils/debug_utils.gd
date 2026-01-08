# debug_utils.gd
class_name DebugUtils

## 씬이 루트로 실행될 때 Control 노드를 화면 중앙에 배치합니다.
static func try_center_if_root(node: Control) -> bool:
	if node.get_parent() != node.get_tree().root:
		return false;

	var viewport_size := node.get_viewport_rect().size
	node.position = (viewport_size - node.size) / 2.0

	return true;
