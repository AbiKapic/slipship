import 'package:flame/components.dart';
import 'package:flame/game.dart';

/// Base class for all game systems
abstract class GameSystem extends Component {
  /// Called when the system is added to the game
  @override
  void onMount() {
    super.onMount();
    initialize();
  }

  /// Initialize the system
  void initialize();

  /// Update the system
  @override
  void update(double dt) {
    super.update(dt);
    onUpdate(dt);
  }

  /// Custom update logic
  void onUpdate(double dt);

  /// Clean up resources
  @override
  void onRemove() {
    cleanup();
    super.onRemove();
  }

  /// Custom cleanup logic
  void cleanup();
}

