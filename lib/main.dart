import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/routes/app_routes.dart';
import 'data/models/user_model.dart';
import 'data/models/habit_model.dart';
import 'core/di/service_locator.dart';
import 'domain/repositories/auth/i_auth_repository.dart';
import 'domain/repositories/habit/i_habit_repository.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(HabitModelAdapter());

  await setupServiceLocator();

  await sl<IAuthRepository>().init();
  await sl<IHabitRepository>().init();
  
  final container = ProviderContainer();
  await container.read(appThemeModeProvider.notifier).init();

  final currentUser = await sl<IAuthRepository>().getCurrentUser();
  final initialRoute = currentUser != null ? AppRoutes.home : AppRoutes.login;

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: HabitlyApp(initialRoute: initialRoute),
    ),
  );
}

class HabitlyApp extends ConsumerWidget {
  final String initialRoute;
  const HabitlyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      title: 'Habitly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
