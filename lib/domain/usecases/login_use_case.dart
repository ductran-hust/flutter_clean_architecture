import 'package:injectable/injectable.dart';

import 'use_case.dart';

@injectable
class LoginUseCase extends UseCase<void, LoginParam> {
  LoginUseCase();

  @override
  Future<bool> call({required LoginParam params}) async {
    // TODO
    return false;
  }
}

class LoginParam {
  LoginParam();
}