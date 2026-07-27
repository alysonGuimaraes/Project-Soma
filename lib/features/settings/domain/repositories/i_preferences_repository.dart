abstract class IPreferencesRepository {
  // Global configs
  Future<void> saveTheme(String themeCode);
  Future<String?> getTheme();

  Future<void> saveCurrency(String currencyCode);
  Future<String?> getCurrency();

  // Dashboard configs
  Future<void> saveDashboardConfig(Map<String, dynamic> configMap);
  Future<Map<String, dynamic>?> getDashboardConfig();
}
