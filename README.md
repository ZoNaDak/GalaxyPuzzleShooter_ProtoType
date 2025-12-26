# WoolGalaxy_ProtoType
털실갤럭시 프로토타입

## 폴더 구조
res://
├── addons/                  # 외부 플러그인
│
├── core/                   # 게임의 핵심 시스템
│   ├── autoloads/           # Autoload에 등록할 스크립트들
│   └── utils/               # 정적 함수 모음
│
├── assets/                  # "여러 곳에서 공통으로 쓰는" 원시 리소스
│   ├── fonts/               # 폰트 파일 (.ttf, .otf)
│   ├── audio/               # 공용 효과음 (UI 클릭음 등)
│   │   ├── music/
│   │   └── sfx/
│   └── art/                 # 공용 스프라이트 (쉐이더용 노이즈, 기본 도형 등)
│
└── game/                    # 실제 게임 로직 및 콘텐츠 (가장 중요한 폴더)
    ├── characters/          # 캐릭터 관련 (플레이어 + 적)
    │   ├── player/          # [자급자족 원칙] 플레이어의 모든 것
    │   │   ├── assets/      # 플레이어 전용 스프라이트/애니메이션
    │   │   ├── states/      # 상태 머신을 쓴다면 상태 스크립트들
    │   │   ├── player.tscn
    │   │   └── player.gd
    │   └── enemies/         # 적들도 종류별로 폴더링
    │
    ├── data/                # 게임 전반에 쓰이는 데이터 (ItemData 등 Custom Resource)
    │
    ├── scenes/              # 게임 씬 (Title, Main, GameOver 등)
    │
    ├── world/               # 맵, 레벨 디자인 관련
    │   ├── levels/          # 실제 플레이 가능한 씬 (Level_01.tscn)
    │   └── backgrounds/     # 패럴랙스 배경 이미지 등
    │
    ├── misc/                # 상호작용 가능한 아이템, 투사체 등
    │
    └── ui/                  # UI 시스템