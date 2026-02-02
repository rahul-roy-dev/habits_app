import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/presentation/widgets/common/custom_button.dart';
import 'package:habits_app/presentation/widgets/common/custom_input.dart';
import 'package:habits_app/presentation/widgets/common/custom_toast.dart';
import 'package:habits_app/core/di/service_locator.dart';
import 'package:habits_app/presentation/viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authViewModel = sl<AuthViewModel>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: _authViewModel,
          builder: (context, child) {
            return Stack(
              children: [     
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            'Create Your\nAccount',
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
                            'Join the community and start building better habits today.',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? AppColors.secondaryText
                                  : AppColors.lightSecondaryText,
                            ),
                          ),
                          const SizedBox(height: 40),
                          CustomInput(
                            label: 'Full Name',
                            hint: 'John Doe',
                            controller: _nameController,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: isDark
                                  ? AppColors.secondaryText
                                  : AppColors.lightSecondaryText,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomInput(
                            label: 'Email Address',
                            hint: 'name@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: isDark
                                  ? AppColors.secondaryText
                                  : AppColors.lightSecondaryText,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomInput(
                            label: 'Password',
                            hint: '••••••••',
                            controller: _passwordController,
                            isPassword: _obscurePassword,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: isDark
                                  ? AppColors.secondaryText
                                  : AppColors.lightSecondaryText,
                            ),
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
                          const SizedBox(height: 200),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.0),
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        stops: const [0.0, 0.3],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'By creating an account, you agree to our ',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.secondaryText
                                  : AppColors.lightSecondaryText,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: AppColors.primaryAccent,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.primaryAccent,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Create Account',
                          onPressed: _handleRegister,
                          isLoading: _authViewModel.isLoading,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.secondaryText
                                    : AppColors.lightSecondaryText,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  color: AppColors.primaryAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authViewModel.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true); // Return true for success
      } else {
        CustomToast.showError(
          context,
          _authViewModel.errorMessage ?? 'Registration failed',
        );
      }
    }
  }
}
