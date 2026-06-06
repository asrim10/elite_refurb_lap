import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/laptop/data/repositories/laptop_repository.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/domain/repositories/laptop_repository.dart';

final getMyListingsUsecaseProvider = Provider<GetMyListingsUsecase>((ref) {
  final laptopRepository = ref.read(laptopRepositoryProvider);
  return GetMyListingsUsecase(laptopRepository: laptopRepository);
});

class GetMyListingsUsecase
    implements UsecaseWithoutParams<List<LaptopEntity>> {
  final ILaptopRepository _laptopRepository;

  GetMyListingsUsecase({required ILaptopRepository laptopRepository})
      : _laptopRepository = laptopRepository;

  @override
  Future<Either<Failure, List<LaptopEntity>>> call() {
    return _laptopRepository.getMyListings();
  }
}
