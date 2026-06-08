import 'package:EliteReurbLap/features/auth/domain/entities/auth_entity.dart';
import 'package:EliteReurbLap/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:EliteReurbLap/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:EliteReurbLap/features/auth/domain/usecases/login_usecase.dart';
import 'package:EliteReurbLap/features/auth/domain/usecases/logout_usecase.dart';
import 'package:EliteReurbLap/features/auth/domain/usecases/register_usecase.dart';
import 'package:EliteReurbLap/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:EliteReurbLap/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final GetProfileUsecase _getProfileUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _getProfileUsecase = ref.read(getProfileUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    return const AuthState();
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final user = AuthEntity(
      fullName: fullName,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
    );

    final result = await _registerUsecase(RegisterUsecaseParams(user: user));

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (isRegistered) => state = state.copyWith(
        status: isRegistered ? AuthStatus.registered : AuthStatus.error,
        errorMessage: isRegistered ? null : 'Registration failed',
      ),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _loginUsecase(
      LoginUsecaseParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (authEntity) => state = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: authEntity,
      ),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        authEntity: null,
      ),
    );
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (authEntity) => state = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: authEntity,
      ),
    );
  }

  Future<void> getProfile() async {
    state = state.copyWith(status: AuthStatus.profileLoading);

    final result = await _getProfileUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (authEntity) => state = state.copyWith(
        status: AuthStatus.profileLoaded,
        authEntity: authEntity,
        imageVersion: state.imageVersion,
      ),
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? username,
    String? phoneNumber,
    String? imageUrl,
  }) async {
    state = state.copyWith(status: AuthStatus.profileUpdating);

    final result = await _updateProfileUsecase(
      UpdateProfileUsecaseParams(
        fullName: fullName,
        username: username,
        phoneNumber: phoneNumber,
        imageUrl: imageUrl,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (authEntity) => state = state.copyWith(
        status: AuthStatus.profileUpdated,
        authEntity: authEntity,
        imageVersion: state.imageVersion + 1,
      ),
    );
  }
}
