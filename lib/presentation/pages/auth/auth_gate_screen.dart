import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/presentation/providers/auth_provider.dart';
import 'package:habits_app/presentation/routes/app_routes.dart';
import 'package:habits_app/presentation/pages/auth/login_screen.dart';

class AuthGateScreen extends ConsumerStatefulWidget {
  const AuthGateScreen({super.key});

  @override
  ConsumerState<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends ConsumerState<AuthGateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectIfNeeded());
  }

  void _redirectIfNeeded() {
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState.isLoading) return;
    if (authState.currentUser != null) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (!mounted) return;
      if (next.isLoading) return;
      if (next.currentUser != null) _redirectIfNeeded();
    });

    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authState.currentUser != null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return const LoginScreen();
  }
}
