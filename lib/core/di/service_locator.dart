import 'package:get_it/get_it.dart';

// Repositories
import 'package:habits_app/data/repositories/auth_repository.dart';
import 'package:habits_app/data/repositories/habit_repository.dart';
import 'package:habits_app/domain/repositories/auth/i_auth_repository.dart';
import 'package:habits_app/domain/repositories/auth/i_authenticator.dart';
import 'package:habits_app/domain/repositories/auth/i_user_registration.dart';
import 'package:habits_app/domain/repositories/auth/i_user_manager.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_repository.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_reader.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_writer.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_completion.dart';

// Use Cases - Auth
import 'package:habits_app/domain/usecases/auth/login_usecase.dart';
import 'package:habits_app/domain/usecases/auth/logout_usecase.dart';
import 'package:habits_app/domain/usecases/auth/register_usecase.dart';
import 'package:habits_app/domain/usecases/auth/get_current_user_usecase.dart';

// Use Cases - Habit
import 'package:habits_app/domain/usecases/habit/get_habits_usecase.dart';
import 'package:habits_app/domain/usecases/habit/add_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/update_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/delete_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/toggle_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/get_habit_stats_usecase.dart';

// ViewModels
import 'package:habits_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:habits_app/presentation/viewmodels/habit_viewmodel.dart';
import 'package:habits_app/presentation/viewmodels/theme_viewmodel.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ========== Repositories (Data Layer) ==========
  // Register concrete implementations as singletons
  
  // Auth Repository - implements all auth-related interfaces
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  
  // Register segregated interfaces pointing to the same implementation
  sl.registerLazySingleton<IAuthRepository>(() => sl<AuthRepository>());
  sl.registerLazySingleton<IAuthenticator>(() => sl<AuthRepository>());
  sl.registerLazySingleton<IUserRegistration>(() => sl<AuthRepository>());
  sl.registerLazySingleton<IUserManager>(() => sl<AuthRepository>());

  // Habit Repository - implements all habit-related interfaces
  sl.registerLazySingleton<HabitRepository>(() => HabitRepository());
  
  // Register segregated interfaces pointing to the same implementation
  sl.registerLazySingleton<IHabitRepository>(() => sl<HabitRepository>());
  sl.registerLazySingleton<IHabitReader>(() => sl<HabitRepository>());
  sl.registerLazySingleton<IHabitWriter>(() => sl<HabitRepository>());
  sl.registerLazySingleton<IHabitCompletion>(() => sl<HabitRepository>());

  // ========== Use Cases (Domain Layer) ==========
  
  // Auth Use Cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<IAuthenticator>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<IAuthenticator>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<IUserRegistration>()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<IAuthenticator>()),
  );

  // Habit Use Cases
  sl.registerLazySingleton<GetHabitsUseCase>(
    () => GetHabitsUseCase(sl<IHabitReader>()),
  );
  sl.registerLazySingleton<AddHabitUseCase>(
    () => AddHabitUseCase(sl<IHabitWriter>()),
  );
  sl.registerLazySingleton<UpdateHabitUseCase>(
    () => UpdateHabitUseCase(sl<IHabitWriter>()),
  );
  sl.registerLazySingleton<DeleteHabitUseCase>(
    () => DeleteHabitUseCase(sl<IHabitWriter>()),
  );
  sl.registerLazySingleton<ToggleHabitUseCase>(
    () => ToggleHabitUseCase(sl<IHabitCompletion>()),
  );
  sl.registerLazySingleton<GetHabitStatsUseCase>(
    () => GetHabitStatsUseCase(sl<IHabitReader>()),
  );

  // ========== ViewModels (Presentation Layer) ==========
  
  sl.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(
      loginUseCase: sl<LoginUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      userManager: sl<IUserManager>(),
    ),
  );

  sl.registerLazySingleton<HabitViewModel>(
    () => HabitViewModel(
      getHabitsUseCase: sl<GetHabitsUseCase>(),
      addHabitUseCase: sl<AddHabitUseCase>(),
      updateHabitUseCase: sl<UpdateHabitUseCase>(),
      deleteHabitUseCase: sl<DeleteHabitUseCase>(),
      toggleHabitUseCase: sl<ToggleHabitUseCase>(),
      getHabitStatsUseCase: sl<GetHabitStatsUseCase>(),
    ),
  );

  sl.registerLazySingleton<ThemeViewModel>(() => ThemeViewModel());
}
