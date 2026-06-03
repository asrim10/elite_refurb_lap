import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, AuthEntity>> getProfile();
  Future<Either<Failure, AuthEntity>> updateProfile({
    String? fullName,
    String? username,
    String? imageUrl,
  });
}
