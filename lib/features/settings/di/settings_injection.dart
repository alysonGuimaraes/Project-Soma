import 'package:get_it/get_it.dart';
import 'package:project_soma/features/settings/data/repositories/preferences_repository_impl.dart';
import 'package:project_soma/features/settings/domain/repositories/i_preferences_repository.dart';

Future<void> initSettingsDI() async {
  final dc = GetIt.instance;

  final preferencesRepository = PreferencesRepositoryImpl();

  await preferencesRepository.initPreferences();

  dc.registerSingleton<IPreferencesRepository>(preferencesRepository);
}
