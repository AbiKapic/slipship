/// Base class for all game services
abstract class ServiceBase {
  /// Initialize the service
  Future<void> initialize();

  /// Dispose of the service
  Future<void> dispose();

  /// Check if service is initialized
  bool get isInitialized;
}

