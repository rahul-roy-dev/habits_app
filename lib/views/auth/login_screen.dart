import 'dart:io';
import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/routes/app_routes.dart';
import 'package:habits_app/shared/widgets/custom_button.dart';
import 'package:habits_app/shared/widgets/custom_toast.dart';
import 'package:habits_app/shared/widgets/custom_input.dart';
import 'package:habits_app/core/di/service_locator.dart';
import 'package:habits_app/viewmodels/auth_viewmodel.dart';
import 'package:habits_app/shared/widgets/social_button.dart';
import 'package:habits_app/core/constants/image_paths.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authViewModel = sl<AuthViewModel>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authViewModel.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        CustomToast.showError(
          context,
          _authViewModel.errorMessage ?? 'Login failed',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListenableBuilder(
              listenable: _authViewModel,
              builder: (context, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surface : AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.primaryAccent,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Habitly',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.primaryText
                                : AppColors.lightPrimaryText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.primaryText
                              : AppColors.lightPrimaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your journey to better habits starts here.',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomInput(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomInput(
                        label: 'Password',
                        hint: 'Enter your password',
                        controller: _passwordController,
                        isPassword: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: isDark
                                ? AppColors.secondaryText
                                : AppColors.lightSecondaryText,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: AppColors.primaryAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Sign In',
                        onPressed: _handleLogin,
                        isLoading: _authViewModel.isLoading,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? AppColors.surface
                                  : Colors.grey.shade300,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.secondaryText
                                    : AppColors.lightSecondaryText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? AppColors.surface
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SocialButton(
                        iconPath: AppAssets.googleIcon,
                        text: 'Continue with Google',
                        onPressed: () {},
                      ),
                      if (Platform.isIOS) ...[
                        const SizedBox(height: 12),
                        SocialButton(
                          iconPath: AppAssets.appleIcon,
                          text: 'Continue with Apple',
                          iconColor: isDark ? Colors.white : Colors.black,
                          onPressed: () {},
                        ),
                      ],
                      const SizedBox(height: 24),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.secondaryText
                                    : AppColors.lightSecondaryText,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  AppRoutes.register,
                                );
                                if (result == true && mounted) {
                                  CustomToast.showSuccess(
                                    context,
                                    'Account created Successfully',
                                  );
                                }
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColors.primaryAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
