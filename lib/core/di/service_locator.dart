import 'package:get_it/get_it.dart';

// Repositories
import 'package:habits_app/data/repositories/firebase_auth_repository.dart';
import 'package:habits_app/data/repositories/firestore_habit_repository.dart';
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
import 'package:habits_app/domain/usecases/auth/sign_in_with_google_usecase.dart';

// Use Cases - Habit
import 'package:habits_app/domain/usecases/habit/get_habits_usecase.dart';
import 'package:habits_app/domain/usecases/habit/add_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/update_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/delete_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/toggle_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/get_habit_stats_usecase.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ========== Repositories (Data Layer) ==========
  // Register concrete implementations as singletons
  
  // Auth Repository - Firebase implementation (DIP: depend on interfaces)
  sl.registerLazySingleton<FirebaseAuthRepository>(() => FirebaseAuthRepository());
  sl.registerLazySingleton<IAuthRepository>(() => sl<FirebaseAuthRepository>());
  sl.registerLazySingleton<IAuthenticator>(() => sl<FirebaseAuthRepository>());
  sl.registerLazySingleton<IUserRegistration>(() => sl<FirebaseAuthRepository>());
  sl.registerLazySingleton<IUserManager>(() => sl<FirebaseAuthRepository>());

  // Habit Repository - Firestore implementation
  sl.registerLazySingleton<FirestoreHabitRepository>(() => FirestoreHabitRepository());
  sl.registerLazySingleton<IHabitRepository>(() => sl<FirestoreHabitRepository>());
  sl.registerLazySingleton<IHabitReader>(() => sl<FirestoreHabitRepository>());
  sl.registerLazySingleton<IHabitWriter>(() => sl<FirestoreHabitRepository>());
  sl.registerLazySingleton<IHabitCompletion>(() => sl<FirestoreHabitRepository>());

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
  sl.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(sl<IAuthenticator>()),
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
}
