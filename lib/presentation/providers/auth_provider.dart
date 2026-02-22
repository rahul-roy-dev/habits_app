import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/core/constants/app_strings.dart';
import 'dependency_providers.dart';

part 'auth_provider.g.dart';

class AuthState {
  final UserEntity? currentUser;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => currentUser != null;

  AuthState copyWith({
    UserEntity? currentUser,
    bool? isLoading,
    String? errorMessage,
    bool clearCurrentUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      currentUser: clearCurrentUser ? null : (currentUser ?? this.currentUser),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    final authState = const AuthState(isLoading: true);
    
    ref.read(getCurrentUserUseCaseProvider).execute().then((user) {
      state = state.copyWith(
        currentUser: user,
        isLoading: false,
      );
    }).catchError((error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    });
    
    return authState;
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await ref.read(getCurrentUserUseCaseProvider).execute();
      state = state.copyWith(currentUser: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(clearError: true);

    try {
      final user = await ref.read(loginUseCaseProvider).execute(email, password);

      if (user == null) {
        state = state.copyWith(errorMessage: AppStrings.invalidEmailOrPassword);
        return false;
      }

      state = state.copyWith(currentUser: user);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // TODO: Sign in with Google — re-enable from login_screen after Google Cloud config (Web client ID).
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await ref.read(signInWithGoogleUseCaseProvider).execute();

      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: AppStrings.signInWithGoogleFailed,
        );
        return false;
      }

      state = state.copyWith(currentUser: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    
    try {
      final success = await ref.read(registerUseCaseProvider).execute(name, email, password);
      
      if (!success) {
        state = state.copyWith(
          isLoading: false, 
          errorMessage: AppStrings.emailAlreadyExists
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
      
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).execute();
    state = const AuthState();
  }

  Future<void> updateProfile(UserEntity updatedUser) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(userManagerProvider).updateUser(updatedUser);
      state = state.copyWith(currentUser: updatedUser, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteAccount() async {
    if (state.currentUser == null) return;
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(userManagerProvider).deleteUser(state.currentUser!.id);
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
