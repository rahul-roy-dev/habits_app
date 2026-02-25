import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/domain/repositories/auth/i_authenticator.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';

/// Use case for getting the current authenticated user
class GetCurrentUserUseCase extends NoParamsUseCase<UserEntity?> {
  final IAuthenticator _authenticator;

  GetCurrentUserUseCase(this._authenticator);

  @override
  Future<UserEntity?> call() async {
    return await _authenticator.getCurrentUser();
  }

  Future<UserEntity?> execute() async {
    return await call();
  }
}
