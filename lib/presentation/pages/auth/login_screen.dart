import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/presentation/routes/app_routes.dart';
import 'package:habits_app/presentation/widgets/common/custom_button.dart';
import 'package:habits_app/presentation/widgets/common/custom_toast.dart';
import 'package:habits_app/presentation/widgets/common/custom_input.dart';
import 'package:habits_app/presentation/providers/auth_provider.dart';
import 'package:habits_app/presentation/providers/ui_state_providers.dart';
import 'package:habits_app/presentation/widgets/common/social_button.dart';
import 'package:habits_app/core/constants/image_paths.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/app_strings.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoggingIn = true);
    final success = await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _isLoggingIn = false);
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      CustomToast.showError(
        context,
        ref.read(authProvider).errorMessage ?? AppStrings.invalidEmailOrPassword,
      );
    }
  }

  void _handleGoogleSignIn() async {
    // TODO: Sign in with Google — enable after Google Cloud / Firebase Web client ID
    //       configuration is done. Then call signInWithGoogle() and handle success/navigation.
    if (!mounted) return;
    CustomToast.showError(context, AppStrings.signInWithGoogleComingNext);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final obscurePassword = ref.watch(passwordVisibilityProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingXl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppDimensions.spacingMd),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.spacingMd),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surface : AppColors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: AppDimensions.opacityXxs),
                                  blurRadius: AppDimensions.shadowBlurSm,
                                  offset: const Offset(0, AppDimensions.shadowOffsetY),
                                ),
                              ],
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: AppColors.primaryAccent,
                        size: AppDimensions.iconSizeXxl,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingMd),
                  Center(
                    child: Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeHuge,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.primaryText
                            : AppColors.lightPrimaryText,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingXl),
                  Center(
                    child: Text(
                      AppStrings.welcomeBack,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeMassive,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.primaryText
                            : AppColors.lightPrimaryText,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingXs),
                  Center(
                    child: Text(
                      AppStrings.journeyStartsHere,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeXl,
                        color: isDark
                            ? AppColors.secondaryText
                            : AppColors.lightSecondaryText,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingXl),
                  CustomInput(
                    label: AppStrings.email,
                    hint: AppStrings.enterEmail,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.emailRequired;
                      }
                      if (!value.contains('@')) return AppStrings.validEmail;
                      return null;
                    },
                  ),
                  SizedBox(height: AppDimensions.spacingLg),
                  CustomInput(
                    label: AppStrings.password,
                    hint: AppStrings.enterPassword,
                    controller: _passwordController,
                    isPassword: obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: isDark
                            ? AppColors.secondaryText
                            : AppColors.lightSecondaryText,
                      ),
                      onPressed: () => ref.read(passwordVisibilityProvider.notifier).toggle(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.passwordRequired;
                      }
                      if (value.length < AppDimensions.passwordMinLength) {
                        return AppStrings.passwordMinLength;
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        AppStrings.forgotPassword,
                        style: const TextStyle(color: AppColors.primaryAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingMd),
                  CustomButton(
                    text: AppStrings.signIn,
                    onPressed: _handleLogin,
                    isLoading: _isLoggingIn,
                  ),
                  SizedBox(height: AppDimensions.spacingXl),
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
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                        child: Text(
                          AppStrings.or,
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
                  SizedBox(height: AppDimensions.spacingXl),
                  SocialButton(
                    iconPath: AppAssets.googleIcon,
                    text: AppStrings.continueWithGoogle,
                    onPressed: _isLoggingIn ? () {} : _handleGoogleSignIn,
                  ),
                  if (Platform.isIOS) ...[
                    SizedBox(height: AppDimensions.spacingMd),
                    SocialButton(
                      iconPath: AppAssets.appleIcon,
                      text: AppStrings.continueWithApple,
                      iconColor: isDark ? Colors.white : Colors.black,
                      onPressed: () {},
                    ),
                  ],
                  SizedBox(height: AppDimensions.spacingXl),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.dontHaveAccount,
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
                                AppStrings.accountCreatedSuccessfully,
                              );
                            }
                          },
                          child: Text(
                            AppStrings.signUp,
                            style: const TextStyle(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingMd),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
