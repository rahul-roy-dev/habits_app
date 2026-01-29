import 'package:flutter/material.dart';
import 'package:habits_app/views/placeholder_screen.dart';
import 'package:habits_app/views/auth/login_screen.dart';
import 'package:habits_app/views/auth/register_screen.dart';
import 'package:habits_app/views/home/home_screen.dart';
import 'package:habits_app/views/habits/add_habit_screen.dart';
import 'package:habits_app/data/models/habit_model.dart';
import 'package:habits_app/views/profile/profile_screen.dart';
import 'package:habits_app/views/profile/account_settings_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String addHabit = '/add-habit';
  static const String editHabit = '/edit-habit';
  static const String profile = '/profile';
  static const String accountSettings = '/account-settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addHabit:
        final habit = settings.arguments as HabitModel?;
        return MaterialPageRoute(builder: (_) => AddHabitScreen(habit: habit));
      case editHabit:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Edit Habit'),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case accountSettings:
        return MaterialPageRoute(builder: (_) => const AccountSettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
