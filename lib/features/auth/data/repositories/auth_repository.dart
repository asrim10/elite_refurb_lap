import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/auth/data/datasources/auth_datasource.dart';
import 'package:EliteReurbLap/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:EliteReurbLap/features/auth/data/models/auth_api_model.dart';
import 'package:EliteReurbLap/features/auth/domain/entities/auth_entity.dart';
import 'package:EliteReurbLap/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    authRemoteDatasource: ref.read(authRemoteDatasourceProvider),
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource _authRemoteDataSource;

  AuthRepository({required IAuthRemoteDataSource authRemoteDatasource})
    : _authRemoteDataSource = authRemoteDatasource;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    return Left(ApiFailure(message: 'Not available offline'));
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final apiModel = await _authRemoteDataSource.login(email, password);
      if (apiModel != null) return Right(apiModel.toEntity());
      return const Left(ApiFailure(message: 'Invalid Credentials'));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Login failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _authRemoteDataSource.logout();
      return const Right(true);
    } catch (e) {
      return Left(ApiFailure(message: 'Failed to logout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    try {
      final apiModel = AuthApiModel.fromEntity(user);
      await _authRemoteDataSource.register(apiModel);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Registration failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getProfile() async {
    try {
      final apiModel = await _authRemoteDataSource.getProfile();
      return Right(apiModel.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to get profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfile({
    String? fullName,
    String? username,
    String? phoneNumber,
    String? imageUrl,
  }) async {
    try {
      final apiModel = await _authRemoteDataSource.updateProfile(
        fullName: fullName,
        username: username,
        phoneNumber: phoneNumber,
        imageUrl: imageUrl,
      );
      return Right(apiModel.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to update profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
