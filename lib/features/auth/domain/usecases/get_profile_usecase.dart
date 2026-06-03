import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/auth/data/repositories/auth_repository.dart';
import 'package:EliteReurbLap/features/auth/domain/entities/auth_entity.dart';
import 'package:EliteReurbLap/features/auth/domain/repositories/auth_repository.dart';

//Provider for GetProfileUsecase
final getProfileUsecaseProvider = Provider<GetProfileUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetProfileUsecase(authRepository: authRepository);
});

class GetProfileUsecase implements UsecaseWithoutParams<AuthEntity> {
  final IAuthRepository _authRepository;

  GetProfileUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call() {
    return _authRepository.getProfile();
  }
}
