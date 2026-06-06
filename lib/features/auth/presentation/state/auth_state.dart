import 'package:EliteReurbLap/features/auth/domain/entities/auth_entity.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  profileLoading,
  profileLoaded,
  profileUpdating,
  profileUpdated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? authEntity;
  final String? errorMessage;
  final int imageVersion;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authEntity,
    this.errorMessage,
    this.imageVersion = 0,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? authEntity,
    String? errorMessage,
    int? imageVersion,
  }) {
    return AuthState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: errorMessage,
      imageVersion: imageVersion ?? this.imageVersion,
    );
  }

  @override
  List<Object?> get props => [status, authEntity, errorMessage, imageVersion];
}
