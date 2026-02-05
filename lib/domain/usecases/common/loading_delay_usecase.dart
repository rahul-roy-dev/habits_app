import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';

class LoadingDelayUseCase extends NoParamsUseCase<void> {
  LoadingDelayUseCase();

  @override
  Future<void> call() async {
    await Future.delayed(AppValues.loadingAnimationDuration);
  }

  Future<void> execute() async {
    return await call();
  }
}
