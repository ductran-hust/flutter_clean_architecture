import 'package:injectable/injectable.dart';

/// Base use case — throws [Failure] on error instead of returning Either.
/// Controllers catch errors via BaseController.launch().
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

abstract class NoParamsUseCase<T> {
  Future<T> call();
}

@injectable
class NoParams {
  const NoParams();
}
