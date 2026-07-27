class PreferencesModel {
  final String theme;
  final String currency;
  final Map<String, dynamic> dashboardConfig;

  // Define the keys used to store preferences in the JSON file.
  static const String themeKey = 'USER_PREFERENCE_THEME';
  static const String currencyKey = 'USER_PREFERENCE_CURRENCY';
  static const String dashboardKey = 'USER_PREFERENCE_DASHBOARD_CONFIG';

  PreferencesModel({
    required this.theme,
    required this.currency,
    required this.dashboardConfig,
  });

  // Defines the default values used when no preferences are available.
  factory PreferencesModel.defaultValues() {
    return PreferencesModel(
      theme: 'light',
      currency: 'BRL',
      dashboardConfig: {
        // TODO: Define the default dashboard configuration.
        'dashboard_type': 'test',
      },
    );
  }

  Map<String, dynamic> toMap() {
    return {
      themeKey: theme,
      currencyKey: currency,
      dashboardKey: dashboardConfig,
    };
  }
}
