import 'package:flutter_clean_architecture/shared/entities/user_entity.dart';

abstract interface class UserRepository {
  Future<UserEntity> getCurrentUser();
  Future<void> saveUser(UserEntity user);
  Future<void> clearUser();
}
