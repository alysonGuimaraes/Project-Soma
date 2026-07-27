import 'dart:convert';
import 'dart:io';

import 'package:project_soma/features/settings/data/models/preferences_model.dart';
import 'package:project_soma/features/settings/domain/repositories/i_preferences_repository.dart';

class PreferencesRepositoryImpl implements IPreferencesRepository {
  File? _preferencesFile;
  Map<String, dynamic> _cache = {};

  /// Load existing preferences from disk or apply default values when
  /// the file is missing, empty, or cannot be decoded.
  Future<void> initPreferences() async {
    // Use the current working directory to store the preferences file.
    final preferencesDirectory = Directory.current;
    _preferencesFile = File('${preferencesDirectory.path}/preferences.json');

    if (await _preferencesFile!.exists()) {
      try {
        final String fileAsJsonString = await _preferencesFile!.readAsString();
        if (fileAsJsonString.isNotEmpty) {
          _cache = jsonDecode(fileAsJsonString) as Map<String, dynamic>;
        } else {
          _applyDefaultValues();
        }
      } catch (e) {
        _applyDefaultValues();
      }
    } else {
      await _preferencesFile!.create();

      _applyDefaultValues();
    }
  }

  void _applyDefaultValues() async {
    final defaultSettings = PreferencesModel.defaultValues();
    _cache = defaultSettings.toMap();

    await _saveToDisk();
  }

  Future<void> _saveToDisk() async {
    if (_preferencesFile == null) return;

    final String jsonString = jsonEncode(_cache);
    await _preferencesFile!.writeAsString(jsonString);
  }

  @override
  Future<String?> getCurrency() {
    // TODO: implement getCurrency
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> getDashboardConfig() {
    // TODO: implement getDashboardConfig
    throw UnimplementedError();
  }

  @override
  Future<String?> getTheme() async {
    return _cache[PreferencesModel.themeKey] as String?;
  }

  @override
  Future<void> saveCurrency(String currencyCode) {
    // TODO: implement saveCurrency
    throw UnimplementedError();
  }

  @override
  Future<void> saveDashboardConfig(Map<String, dynamic> configMap) {
    // TODO: implement saveDashboardConfig
    throw UnimplementedError();
  }

  @override
  Future<void> saveTheme(String themeCode) async {
    _cache[PreferencesModel.themeKey] = themeCode;
    await _saveToDisk();
  }
}
