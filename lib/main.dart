import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'presentation/routes/app_routes.dart';
import 'data/models/user_model.dart';
import 'data/models/habit_model.dart';
import 'core/di/service_locator.dart';
import 'domain/repositories/i_auth_repository.dart';
import 'domain/repositories/i_habit_repository.dart';
import 'presentation/viewmodels/theme_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(HabitModelAdapter());

  await setupServiceLocator();

  await sl<IAuthRepository>().init();
  await sl<IHabitRepository>().init();
  await sl<ThemeViewModel>().init();

  final currentUser = await sl<IAuthRepository>().getCurrentUser();
  final initialRoute = currentUser != null ? AppRoutes.home : AppRoutes.login;

  runApp(HabitlyApp(initialRoute: initialRoute));
}

class HabitlyApp extends StatelessWidget {
  final String initialRoute;
  const HabitlyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = sl<ThemeViewModel>();

    return ListenableBuilder(
      listenable: themeViewModel,
      builder: (context, child) {
        return MaterialApp(
          title: 'Habitly',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeViewModel.themeMode,
          initialRoute: initialRoute,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}
