import 'package:get_it/get_it.dart';
import 'package:habits_app/data/repositories/auth_repository.dart';
import 'package:habits_app/data/repositories/habit_repository.dart';
import 'package:habits_app/abstracts/i_auth_repository.dart';
import 'package:habits_app/abstracts/i_habit_repository.dart';
import 'package:habits_app/viewmodels/auth_viewmodel.dart';
import 'package:habits_app/viewmodels/habit_viewmodel.dart';
import 'package:habits_app/viewmodels/theme_viewmodel.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<IAuthRepository>(() => AuthRepository());
  sl.registerLazySingleton<IHabitRepository>(() => HabitRepository());

  sl.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(repository: sl<IAuthRepository>()),
  );

  sl.registerLazySingleton<HabitViewModel>(
    () => HabitViewModel(repository: sl<IHabitRepository>()),
  );

  sl.registerLazySingleton<ThemeViewModel>(() => ThemeViewModel());
}
