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
}
