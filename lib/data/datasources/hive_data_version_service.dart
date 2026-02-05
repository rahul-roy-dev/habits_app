import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/domain/repositories/data/i_data_version_service.dart';

/// Service responsible for managing Hive data versioning and migration
class HiveDataVersionService implements IDataVersionService {
  @override
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt('hive_data_version') ?? 0;

    if (storedVersion != AppValues.hiveDataVersion) {
      await _clearAllBoxes();
      await _updateVersion(prefs);
    }
  }

  /// Clears all Hive boxes from disk
  Future<void> _clearAllBoxes() async {
    try {
      await Hive.deleteBoxFromDisk(AppValues.habitBoxName);
    } catch (_) {}
    
    try {
      await Hive.deleteBoxFromDisk(AppValues.userBoxName);
    } catch (_) {}
    
    try {
      await Hive.deleteBoxFromDisk(AppValues.sessionBoxName);
    } catch (_) {}
    
    try {
      await Hive.deleteBoxFromDisk(AppValues.themeBoxName);
    } catch (_) {}
  }

  Future<void> _updateVersion(SharedPreferences prefs) async {
    await prefs.setInt('hive_data_version', AppValues.hiveDataVersion);
  }

  /// Gets the current stored data version
  @override
  Future<int> getStoredVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('hive_data_version') ?? 0;
  }

  /// Gets the expected data version from AppValues
  @override
  int getExpectedVersion() {
    return AppValues.hiveDataVersion;
  }

  /// Checks if a migration is needed
  @override
  Future<bool> needsMigration() async {
    final storedVersion = await getStoredVersion();
    return storedVersion != getExpectedVersion();
  }
}
