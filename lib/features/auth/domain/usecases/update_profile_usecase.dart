import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/auth/data/repositories/auth_repository.dart';
import 'package:EliteReurbLap/features/auth/domain/entities/auth_entity.dart';
import 'package:EliteReurbLap/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUsecaseParams extends Equatable {
  final String? fullName;
  final String? username;
  final String? phoneNumber;
  final String? imageUrl;

  const UpdateProfileUsecaseParams({
    this.fullName,
    this.username,
    this.phoneNumber,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [fullName, username, phoneNumber, imageUrl];
}

//Provider for UpdateProfileUsecase
final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UpdateProfileUsecase(authRepository: authRepository);
});

class UpdateProfileUsecase
    implements UsecaseWithParams<AuthEntity, UpdateProfileUsecaseParams> {
  final IAuthRepository _authRepository;
  UpdateProfileUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(UpdateProfileUsecaseParams params) {
    return _authRepository.updateProfile(
      fullName: params.fullName,
      username: params.username,
      phoneNumber: params.phoneNumber,
      imageUrl: params.imageUrl,
    );
  }
}
