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
    String? phoneNumber,
    String? imageUrl,
  });

  /// Sends a password reset email to the given email address.
  Future<Either<Failure, void>> requestPasswordReset(String email);

  /// Resets the password using a valid reset token.
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
}
