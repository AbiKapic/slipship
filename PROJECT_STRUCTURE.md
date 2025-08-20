# ShipSlip Project Structure

## Overview
This document describes the organized folder structure for the ShipSlip Flutter/Flame game project.

## Directory Structure

```
lib/
├── game/                 # Main game logic, Router/overlays, asset preloader
│   ├── ship_slip_game.dart
│   └── components/       # Game-specific components
│       ├── player.dart
│       ├── ice_area.dart
│       ├── snow_area.dart
│       └── finish_zone.dart
├── world/                # Levels, map loaders (Tiled), spawners
│   └── map_loader.dart   # Tiled map loading service
├── systems/              # Game systems (AI, physics, etc.)
│   └── game_system.dart  # Base system class
├── input/                # Input handling
│   └── input_handler.dart # Joystick and input management
├── services/             # Game services
│   └── service_base.dart # Base service class
├── utils/                # Utilities and helpers
│   └── asset_keys.dart   # Centralized asset path constants
└── main.dart             # App entry point

assets/
├── images/               # Sprites and atlases
│   └── game_tile_set.png
├── tiles/                # Tiled tilesets
│   └── snowy_terrain.png
├── maps/                 # Tiled tileset definitions
│   └── snowy_terrain.tsx
├── levels/               # Tiled level maps
│   ├── background.tmx
│   ├── snowy_world.tmx
│   ├── snowy_world_complete.tmx
│   ├── snowy_world_final.tmx
│   └── snowy_world_rich.tmx
├── audio/                # Sound effects and music (placeholder)
├── fonts/                # Custom fonts (placeholder)
└── levels/               # Level-specific assets (placeholder)

test/
├── game/                 # Flame test files for components & systems
└── golden/               # Golden tests for UI overlays
```

## Key Benefits

1. **Separation of Concerns**: Each directory has a specific responsibility
2. **Scalability**: Easy to add new systems, components, and services
3. **Maintainability**: Clear organization makes code easier to find and modify
4. **Reusability**: Components and systems can be easily reused across levels
5. **Testing**: Organized structure makes unit and integration testing straightforward

## Usage Examples

### Loading a Map
```dart
import 'package:shipslip/world/map_loader.dart';

final map = await MapLoader.loadLevel('snowy_world');
```

### Using Asset Keys
```dart
import 'package:shipslip/utils/asset_keys.dart';

final image = await images.load(AssetKeys.snowyTerrain);
```

### Creating Input Handler
```dart
import 'package:shipslip/input/input_handler.dart';

final inputHandler = InputHandler();
final joystick = inputHandler.createJoystick(screenSize);
```

## Future Additions

- **Audio Service**: For managing sound effects and music
- **Save Service**: For game progress persistence
- **Analytics Service**: For game metrics and player behavior
- **Collision System**: For physics and collision detection
- **AI System**: For enemy behavior and pathfinding
- **Spawn System**: For dynamic object creation

