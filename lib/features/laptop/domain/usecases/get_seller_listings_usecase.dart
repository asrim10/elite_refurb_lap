import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/laptop/data/repositories/laptop_repository.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/domain/repositories/laptop_repository.dart';

class GetSellerListingsParams extends Equatable {
  final String sellerId;

  const GetSellerListingsParams({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}

final getSellerListingsUsecaseProvider =
    Provider<GetSellerListingsUsecase>((ref) {
  final laptopRepository = ref.read(laptopRepositoryProvider);
  return GetSellerListingsUsecase(laptopRepository: laptopRepository);
});

class GetSellerListingsUsecase
    implements
        UsecaseWithParams<List<LaptopEntity>, GetSellerListingsParams> {
  final ILaptopRepository _laptopRepository;

  GetSellerListingsUsecase({required ILaptopRepository laptopRepository})
      : _laptopRepository = laptopRepository;

  @override
  Future<Either<Failure, List<LaptopEntity>>> call(
      GetSellerListingsParams params) {
    return _laptopRepository.getSellerListings(params.sellerId);
  }
}
