abstract class BaseUseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Base class for use cases that don't require parameters
abstract class NoParamsUseCase<Type> {
  Future<Type> call();
}

/// Empty parameters class for use cases that don't need input
class NoParams {
  const NoParams();
}
