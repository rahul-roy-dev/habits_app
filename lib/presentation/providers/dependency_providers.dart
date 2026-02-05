import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habits_app/core/di/service_locator.dart';

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

// Repositories needed for ViewModel logic
import 'package:habits_app/domain/repositories/auth/i_user_manager.dart';

part 'dependency_providers.g.dart';

@riverpod
LoginUseCase loginUseCase(Ref ref) => sl<LoginUseCase>();

@riverpod
LogoutUseCase logoutUseCase(Ref ref) => sl<LogoutUseCase>();

@riverpod
RegisterUseCase registerUseCase(Ref ref) => sl<RegisterUseCase>();

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) => sl<GetCurrentUserUseCase>();

@riverpod
IUserManager userManager(Ref ref) => sl<IUserManager>();

@riverpod
GetHabitsUseCase getHabitsUseCase(Ref ref) => sl<GetHabitsUseCase>();

@riverpod
AddHabitUseCase addHabitUseCase(Ref ref) => sl<AddHabitUseCase>();

@riverpod
UpdateHabitUseCase updateHabitUseCase(Ref ref) => sl<UpdateHabitUseCase>();

@riverpod
DeleteHabitUseCase deleteHabitUseCase(Ref ref) => sl<DeleteHabitUseCase>();

@riverpod
ToggleHabitUseCase toggleHabitUseCase(Ref ref) => sl<ToggleHabitUseCase>();

@riverpod
GetHabitStatsUseCase getHabitStatsUseCase(Ref ref) => sl<GetHabitStatsUseCase>();
