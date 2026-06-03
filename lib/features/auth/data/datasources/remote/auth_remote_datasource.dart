import 'package:EliteReurbLap/core/api/api_client.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/core/services/storage/token_service.dart';
import 'package:EliteReurbLap/core/services/storage/user_session_service.dart';
import 'package:EliteReurbLap/features/auth/data/datasources/auth_datasource.dart';
import 'package:EliteReurbLap/features/auth/data/models/auth_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService,
        _userSessionService = userSessionService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        fullName: user.fullName,
        username: user.username,
      );

      final token = response.data['token'];
      if (token != null) {
        await _tokenService.saveToken(token);
      }

      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return AuthApiModel.fromJson(data);
    }
    return user;
  }

  @override
  Future<AuthApiModel> getProfile() async {
    final response = await _apiClient.get(ApiEndpoints.whoami);
    final data = response.data['data'] as Map<String, dynamic>;
    final user = AuthApiModel.fromJson(data);

    await _userSessionService.saveUserSession(
      userId: user.id!,
      email: user.email,
      fullName: user.fullName,
      username: user.username,
    );

    return user;
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } finally {
      // Clear local session regardless of server response
      await _tokenService.removeToken();
      await _userSessionService.clearSession();
    }
  }

  @override
  Future<AuthApiModel> updateProfile({
    String? fullName,
    String? username,
    String? imageUrl,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateProfile,
      data: {
        if (fullName != null) 'fullName': fullName,
        if (username != null) 'username': username,
        if (imageUrl != null) 'imageUrl': imageUrl,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final user = AuthApiModel.fromJson(data);

    await _userSessionService.saveUserSession(
      userId: user.id!,
      email: user.email,
      fullName: user.fullName,
      username: user.username,
    );

    return user;
  }
}
