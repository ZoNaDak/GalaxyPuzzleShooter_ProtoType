---
alwaysApply: true
---

# Godot 4.5 게임 개발 .cursorrules

## 핵심 개발 가이드라인

- 오류 감지 및 IDE 지원 향상을 위해 GDScript에서 정적 타이핑(strict typing)을 사용하세요.
- `_ready()` 및 기타 생명주기 함수 구현 시 명시적으로 `super()`를 호출하세요.
- `_ready()` 내부에서 직접 노드를 참조하는 대신 `@onready` 어노테이션을 사용하세요.
- 가능한 경우 상속(Inheritance)보다 구성(Composition)을 선호하세요.
- 노드 간의 느슨한 결합(Loose coupling)을 위해 시그널을 사용하세요.
- Godot의 노드 명명 규칙을 따르세요 (노드는 PascalCase, 메서드는 snake_case).

## 코드 스타일

- 모든 변수와 함수 매개변수에 타입 힌트(Type hints)를 사용하세요.
- 복잡한 함수는 독스트링(docstrings)으로 문서화하세요.
- 메서드는 가능한 한 30줄 미만으로 유지하고 한 가지 기능에 집중하세요.
- 의미 있는 변수명과 함수명을 사용하세요.
- 관련된 속성과 메서드는 함께 그룹화하세요.

## 명명 규칙

- 파일: 모든 파일명에 snake_case 사용 (예: `player_character.gd`, `main_menu.tscn`)
- 클래스: `class_name`을 사용하는 커스텀 클래스명에 PascalCase 사용 (예: `PlayerCharacter`)
- 변수: 멤버 변수를 포함한 모든 변수에 snake_case 사용 (예: `health_points`)
- 상수: 상수에 ALL_CAPS_SNAKE_CASE 사용 (예: `MAX_HEALTH`)
- 함수: 생명주기 함수를 포함한 모든 함수에 snake_case 사용 (예: `move_player()`)
- 열거형(Enums): 타입명에는 PascalCase, 값에는 ALL_CAPS_SNAKE_CASE 사용
- 노드: 씬 트리의 노드 이름에 PascalCase 사용 (예: `PlayerCharacter`, `MainCamera`)
- 시그널: 이벤트 이름은 과거형 snake_case 사용 (예: `health_depleted`, `enemy_defeated`)

## 씬(Scene) 구조

- 성능 향상을 위해 씬 트리의 깊이를 최소화하세요.
- 재사용 가능한 컴포넌트에는 씬 상속을 사용하세요.
- `queue_free()` 시 적절한 씬 정리(cleanup) 로직을 구현하세요.
- `SubViewport` 노드는 성능에 영향을 주므로 주의해서 사용하세요.
- Godot 씬의 소스 코드를 제공하는 대신, 씬 생성 방법에 대한 단계별 지침을 텍스트로 제공하세요.

## 시그널 모범 사례

- 목적을 설명하는 명확하고 문맥에 맞는 시그널 이름을 사용하세요 (예: `player_health_changed`).
- 안전성 및 IDE 지원 향상을 위해 타입이 지정된 시그널을 활용하세요 (예: `signal item_collected(item_name: String)`).
- 동적 노드는 코드에서 시그널을 연결하고, 정적 관계는 에디터에서 연결하세요.
- 시그널 남용을 피하세요. 빈번한 업데이트가 아닌 중요한 이벤트에만 예약해서 사용하세요.
- 가능하면 전체 노드 참조 대신 필요한 데이터만 시그널 인수로 전달하세요.
- 먼 거리에 있는 노드에 도달해야 하는 전역 시그널에는 오토로드(Autoload) "EventBus" 싱글톤을 사용하세요.
- 여러 부모 노드를 거치는 시그널 버블링(전파)을 최소화하세요.
- 메모리 누수 방지를 위해 노드가 해제(freed)될 때 항상 시그널 연결을 끊으세요.
- 목적과 매개변수를 설명하는 주석으로 시그널을 문서화하세요.

## 리소스 관리

- `_exit_tree()`에서 적절한 리소스 정리를 구현하세요.
- 필수 리소스에는 `preload()`를, 선택적 리소스에는 `load()`를 사용하세요.
- 하위 호환성에 대한 `PackedByteArray` 저장소의 영향을 고려하세요.
- 사용하지 않는 에셋에 대한 리소스 언로딩(unloading)을 구현하세요.

## 성능 최적화 모범 사례

- 노드 그룹은 컬렉션 관리에 신중하게 사용하고, 개별 노드에 자주 구체적으로 접근할 때는 직접적인 노드 참조를 선호하세요.
- 자주 생성되는 객체에는 오브젝트 풀링(Object pooling)을 구현하세요.
- 충돌 감지 최적화를 위해 물리 레이어(Physics layers)를 사용하세요.
- 일반 배열보다 패킹된 배열(`PackedVector2Array` 등)을 선호하세요.

## 에러 처리

- 누락된 리소스에 대해 우아한 대체(graceful fallbacks) 처리를 구현하세요.
- 개발 단계의 오류 확인을 위해 `assert()`를 사용하세요.
- 프로덕션 빌드에서는 오류를 적절히 로깅하세요.
- 멀티플레이어 게임에서는 네트워크 오류를 우아하게 처리하세요.

## 타일맵(TileMap) 구현

- `TileMap` 노드는 더 이상 사용되지 않으므로(deprecated) 대신 여러 개의 `TileMapLayer` 노드를 사용하세요.
- 기존 `TileMap`은 타일맵 하단 패널 도구 상자의 "Extract TileMap layers(타일맵 레이어 추출)" 옵션을 사용하여 변환하세요.
- `TileMapLayer` 노드를 통해 타일맵 레이어에 접근하세요.
- `TileMapLayer.get_navigation_map()`을 사용하도록 내비게이션 코드를 업데이트하세요.
- 레이어별 속성은 개별 `TileMapLayer` 노드에 저장하세요.