import 'package:dio/dio.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/domain/usecases/get_all_laptops_usecase.dart';
import 'package:EliteReurbLap/features/laptop/domain/usecases/get_laptop_by_id_usecase.dart';
import 'package:EliteReurbLap/features/laptop/domain/usecases/get_my_listings_usecase.dart';
import 'package:EliteReurbLap/features/laptop/domain/usecases/get_seller_listings_usecase.dart';
import 'package:EliteReurbLap/features/laptop/domain/usecases/create_laptop_usecase.dart';
import 'package:EliteReurbLap/features/laptop/domain/usecases/update_laptop_usecase.dart';
import 'package:EliteReurbLap/features/laptop/domain/usecases/delete_laptop_usecase.dart';
import 'package:EliteReurbLap/features/laptop/domain/usecases/upload_image_usecase.dart';
import 'package:EliteReurbLap/features/laptop/presentation/state/laptop_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final laptopViewModelProvider =
    NotifierProvider<LaptopViewModel, LaptopState>(
  () => LaptopViewModel(),
);

class LaptopViewModel extends Notifier<LaptopState> {
  late final GetAllLaptopsUsecase _getAllLaptopsUsecase;
  late final GetLaptopByIdUsecase _getLaptopByIdUsecase;
  late final GetMyListingsUsecase _getMyListingsUsecase;
  late final GetSellerListingsUsecase _getSellerListingsUsecase;
  late final CreateLaptopUsecase _createLaptopUsecase;
  late final UpdateLaptopUsecase _updateLaptopUsecase;
  late final DeleteLaptopUsecase _deleteLaptopUsecase;
  late final UploadImageUsecase _uploadImageUsecase;

  @override
  LaptopState build() {
    _getAllLaptopsUsecase = ref.read(getAllLaptopsUsecaseProvider);
    _getLaptopByIdUsecase = ref.read(getLaptopByIdUsecaseProvider);
    _getMyListingsUsecase = ref.read(getMyListingsUsecaseProvider);
    _getSellerListingsUsecase = ref.read(getSellerListingsUsecaseProvider);
    _createLaptopUsecase = ref.read(createLaptopUsecaseProvider);
    _updateLaptopUsecase = ref.read(updateLaptopUsecaseProvider);
    _deleteLaptopUsecase = ref.read(deleteLaptopUsecaseProvider);
    _uploadImageUsecase = ref.read(uploadImageUsecaseProvider);
    return const LaptopState();
  }

  Future<void> getAllLaptops({
    Map<String, dynamic>? queryParameters,
  }) async {
    state = state.copyWith(status: LaptopStatus.loading);

    final result = await _getAllLaptopsUsecase(
      GetAllLaptopsParams(queryParameters: queryParameters),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: LaptopStatus.error,
        errorMessage: failure.message,
      ),
      (laptops) => state = state.copyWith(
        status: LaptopStatus.loaded,
        laptops: laptops,
      ),
    );
  }

  Future<void> getLaptopById(String id) async {
    state = state.copyWith(status: LaptopStatus.loading);

    final result = await _getLaptopByIdUsecase(
      GetLaptopByIdParams(id: id),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: LaptopStatus.error,
        errorMessage: failure.message,
      ),
      (laptop) => state = state.copyWith(
        status: LaptopStatus.loaded,
        selectedLaptop: laptop,
      ),
    );
  }

  Future<void> getMyListings() async {
    state = state.copyWith(status: LaptopStatus.loading);

    final result = await _getMyListingsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: LaptopStatus.error,
        errorMessage: failure.message,
      ),
      (laptops) => state = state.copyWith(
        status: LaptopStatus.loaded,
        laptops: laptops,
      ),
    );
  }

  Future<void> getSellerListings(String sellerId) async {
    state = state.copyWith(status: LaptopStatus.loading);

    final result = await _getSellerListingsUsecase(
      GetSellerListingsParams(sellerId: sellerId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: LaptopStatus.error,
        errorMessage: failure.message,
      ),
      (laptops) => state = state.copyWith(
        status: LaptopStatus.loaded,
        laptops: laptops,
      ),
    );
  }

  Future<void> createLaptop({
    required String title,
    required String brand,
    required String modelName,
    required double price,
    double? originalPrice,
    String condition = 'excellent',
    String? description,
    List<String> images = const [],
    required String processor,
    required int ram,
    required int storage,
    String storageType = 'SSD',
    required double displaySize,
    String? displayResolution,
    String? gpu,
    String? operatingSystem,
    double? batteryLife,
    double? weight,
    String? sellerId,
    String? sellerName,
    int? yearOfManufacture,
    int? warrantyMonths,
    LaptopLocationEntity? location,
    List<String> tags = const [],
  }) async {
    state = state.copyWith(status: LaptopStatus.loading);

    final laptop = LaptopEntity(
      title: title,
      brand: brand,
      modelName: modelName,
      price: price,
      originalPrice: originalPrice,
      condition: condition,
      description: description,
      images: images,
      processor: processor,
      ram: ram,
      storage: storage,
      storageType: storageType,
      displaySize: displaySize,
      displayResolution: displayResolution,
      gpu: gpu,
      operatingSystem: operatingSystem,
      batteryLife: batteryLife,
      weight: weight,
      sellerId: sellerId,
      sellerName: sellerName,
      yearOfManufacture: yearOfManufacture,
      warrantyMonths: warrantyMonths,
      location: location,
      tags: tags,
    );

    final result = await _createLaptopUsecase(
      CreateLaptopParams(laptop: laptop),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: LaptopStatus.error,
        errorMessage: failure.message,
      ),
      (createdLaptop) => state = state.copyWith(
        status: LaptopStatus.created,
        laptops: [...state.laptops, createdLaptop],
      ),
    );
  }

  Future<void> updateLaptop({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    state = state.copyWith(status: LaptopStatus.loading);

    final result = await _updateLaptopUsecase(
      UpdateLaptopParams(id: id, data: data),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: LaptopStatus.error,
        errorMessage: failure.message,
      ),
      (updatedLaptop) => state = state.copyWith(
        status: LaptopStatus.updated,
        laptops: state.laptops
            .map((l) => l.id == updatedLaptop.id ? updatedLaptop : l)
            .toList(),
        selectedLaptop: updatedLaptop,
      ),
    );
  }

  Future<void> deleteLaptop(String id) async {
    state = state.copyWith(status: LaptopStatus.loading);

    final result = await _deleteLaptopUsecase(
      DeleteLaptopParams(id: id),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: LaptopStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: LaptopStatus.deleted,
        laptops: state.laptops.where((l) => l.id != id).toList(),
      ),
    );
  }

  Future<String?> uploadImage(MultipartFile image) async {
    final result = await _uploadImageUsecase(
      UploadImageParams(image: image),
    );

    return result.fold(
      (failure) => null,
      (url) => url,
    );
  }
}
