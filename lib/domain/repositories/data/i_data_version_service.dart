abstract class IDataVersionService {
  Future<void> initialize();
  
  /// Gets the current stored data version
  Future<int> getStoredVersion();
  
  /// Gets the expected data version from app configuration
  int getExpectedVersion();
  
  /// Checks if a migration is needed
  Future<bool> needsMigration();
}
