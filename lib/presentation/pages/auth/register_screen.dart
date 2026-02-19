import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/presentation/widgets/common/custom_button.dart';
import 'package:habits_app/presentation/widgets/common/custom_input.dart';
import 'package:habits_app/presentation/widgets/common/custom_toast.dart';
import 'package:habits_app/presentation/providers/auth_provider.dart';
import 'package:habits_app/presentation/providers/ui_state_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    final authState = ref.watch(authProvider);
    final obscurePassword = ref.watch(registerPasswordVisibilityProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [     
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingXl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDimensions.spacingXl),
                      Text(
                        'Create Your\nAccount',
                        style: TextStyle(
                          fontSize: AppDimensions.fontSizeMassive,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.primaryText
                              : AppColors.lightPrimaryText,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        'Join the community and start building better habits today.',
                        style: TextStyle(
                          fontSize: AppDimensions.fontSizeXl,
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXxxl),
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
                      const SizedBox(height: AppDimensions.spacingLg),
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
                      const SizedBox(height: AppDimensions.spacingLg),
                      CustomInput(
                        label: 'Password',
                        hint: '••••••••',
                        controller: _passwordController,
                        isPassword: obscurePassword,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: isDark
                                ? AppColors.secondaryText
                                : AppColors.lightSecondaryText,
                          ),
                          onPressed: () => ref.read(registerPasswordVisibilityProvider.notifier).toggle(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < AppDimensions.passwordMinLength) {
                            return 'Password must be at least ${AppDimensions.passwordMinLength} characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.formContentSpacing),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingXl),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor.withValues(alpha: AppDimensions.opacityXxs),
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
                          fontSize: AppDimensions.fontSizeSm,
                        ),
                        children: [
                          // Beberapa string masih hardcoded ('Create Your\nAccount',
                          // 'Join the community...', 'Already have an account?')
                          // – idealnya dipindahkan ke AppStrings untuk konsistensi.
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
                      const SizedBox(height: AppDimensions.spacingLg),
                    CustomButton(
                      text: 'Create Account',
                      onPressed: _handleRegister,
                      isLoading: authState.isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacingXl),
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
                      const SizedBox(height: AppDimensions.spacingSm),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authProvider.notifier).register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.pop(context, true);
        });
      } else {
        CustomToast.showError(
          context,
          ref.read(authProvider).errorMessage ?? 'Registration failed',
        );
      }
    }
  }
}
