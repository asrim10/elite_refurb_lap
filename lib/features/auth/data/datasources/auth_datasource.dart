import 'package:EliteReurbLap/features/auth/data/models/auth_api_model.dart';

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel?> getUserById(String authId);
  Future<AuthApiModel> getProfile();
  Future<void> logout();
  Future<AuthApiModel> updateProfile({
    String? fullName,
    String? username,
    String? phoneNumber,
    String? imageUrl,
  });

  /// Sends a password reset email to the given email address.
  Future<void> requestPasswordReset(String email);

  /// Resets the password using a valid reset token.
  Future<void> resetPassword(String token, String newPassword);
}
