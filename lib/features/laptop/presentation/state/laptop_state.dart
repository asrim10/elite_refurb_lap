import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:equatable/equatable.dart';

enum LaptopStatus {
  initial,
  loading,
  loaded,
  created,
  updated,
  deleted,
  error,
}

class LaptopState extends Equatable {
  final LaptopStatus status;
  final List<LaptopEntity> laptops;
  final LaptopEntity? selectedLaptop;
  final String? errorMessage;

  const LaptopState({
    this.status = LaptopStatus.initial,
    this.laptops = const [],
    this.selectedLaptop,
    this.errorMessage,
  });

  LaptopState copyWith({
    LaptopStatus? status,
    List<LaptopEntity>? laptops,
    LaptopEntity? selectedLaptop,
    String? errorMessage,
  }) {
    return LaptopState(
      status: status ?? this.status,
      laptops: laptops ?? this.laptops,
      selectedLaptop: selectedLaptop ?? this.selectedLaptop,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, laptops, selectedLaptop, errorMessage];
}
