# GalaxyPuzzleShooter_ProtoType
A top-down shooter with puzzle mechanics

## Folder Structure

```
res://
├── addons/                  # External plugins
│
├── core/                    # Core game systems
│   ├── autoloads/           # Autoload scripts
│   ├── common/              # Common base classes and scripts
│   └── utils/               # Static utility functions
│
├── config/                  # Configuration
│   ├── resources/           # Custom resources for configuration
│   └── scripts/             # Configuration scripts
│
├── assets/                  # Shared raw resources
│   ├── fonts/               # Font files
│   ├── audio/               # Shared audio
│   │   ├── music/
│   │   └── sfx/
│   ├── art/                 # Shared sprites
│   └── shaders/             # Shader files
│
└── game/                    # Game logic and content
    ├── characters/          # Characters
    │   ├── player/          # Everything about the player
    │   │   ├── assets/      # Player-specific sprites/animations
    │   │   ├── states/      # State machine scripts
    │   │   ├── player.tscn
    │   │   └── player.gd
    │   └── enemies/         # Enemies
    │
    ├── data/                # Game data
    │
    ├── effects/             # Effects
    │
    ├── projectiles/         # Projectiles
    │
    ├── scenes/              # Game scenes
    │
    ├── services/            # Game services
    │
    ├── world/               # Maps and level design
    │
    └── ui/                  # UI system
```

## License

Copyright (c) 2025 ZoNaDak. All Rights Reserved.
This project is shared as a portfolio for viewing purposes only.
See [LICENSE](./LICENSE) for details.
