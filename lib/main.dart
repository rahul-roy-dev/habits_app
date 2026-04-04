import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'core/theme/app_theme.dart';
import 'core/di/service_locator.dart';
import 'core/services/notification_service.dart';
import 'core/services/reminder_overlay_navigator.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/providers/theme_provider.dart';

class _FlutterReminderOverlayNavigator implements ReminderOverlayNavigator {
  _FlutterReminderOverlayNavigator(this._navigatorKey);
  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void pushReminderOverlay({
    required String habitId,
    required String? reminderSlotKey,
    HabitEntity? habit,
    void Function()? onPopped,
  }) {
    _navigatorKey.currentState?.pushNamed(
      AppRoutes.habitReminder,
      arguments: <String, dynamic>{
        'habitId': habitId,
        'reminderSlotKey': reminderSlotKey,
        if (habit != null) 'habit': habit,
      },
    ).then((_) => onPopped?.call());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
  await NotificationService().initialize();
  NotificationService().setReminderOverlayNavigator(
    _FlutterReminderOverlayNavigator(HabitlyApp.navigatorKey),
  );

  runApp(
    const ProviderScope(
      child: HabitlyApp(initialRoute: '/'),
    ),
  );
}

class HabitlyApp extends ConsumerStatefulWidget {
  final String initialRoute;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const HabitlyApp({super.key, required this.initialRoute});

  @override
  ConsumerState<HabitlyApp> createState() => _HabitlyAppState();
}

class _HabitlyAppState extends ConsumerState<HabitlyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NotificationService().handleAppResumed();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      title: 'Habitly',
      navigatorKey: HabitlyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: widget.initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
      builder: (context, child) {
        final brightness = Theme.of(context).brightness;
        final overlay = brightness == Brightness.dark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
              );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
