class SearchFilter {
  final String? laptopType;
  final String? processor;
  final String? ram;
  final String? storage;
  final double minPrice;
  final double maxPrice;

  const SearchFilter({
    this.laptopType,
    this.processor,
    this.ram,
    this.storage,
    this.minPrice = 30000,
    this.maxPrice = 1000000,
  });

  SearchFilter copyWith({
    String? laptopType,
    String? processor,
    String? ram,
    String? storage,
    double? minPrice,
    double? maxPrice,
    bool clearLaptopType = false,
    bool clearProcessor = false,
    bool clearRam = false,
    bool clearStorage = false,
  }) {
    return SearchFilter(
      laptopType: clearLaptopType ? null : (laptopType ?? this.laptopType),
      processor: clearProcessor ? null : (processor ?? this.processor),
      ram: clearRam ? null : (ram ?? this.ram),
      storage: clearStorage ? null : (storage ?? this.storage),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (laptopType != null) params['type'] = laptopType;
    if (processor != null) params['processor'] = processor;
    if (ram != null) params['ram'] = ram;
    if (storage != null) params['storage'] = storage;
    params['min_price'] = minPrice.toStringAsFixed(0);
    params['max_price'] = maxPrice.toStringAsFixed(0);
    return params;
  }

  bool get hasActiveFilters =>
      laptopType != null ||
      processor != null ||
      ram != null ||
      storage != null ||
      minPrice != 30000 ||
      maxPrice != 1000000;

  static const List<String> laptopTypes = [
    'Macbook',
    'Gaming',
    'Ultrabook',
    'Creator',
  ];

  static const List<String> processors = [
    'M1',
    'M2',
    'M3',
    'Intel i7',
    'Intel i9',
  ];

  static const List<String> ramOptions = [
    '8GB',
    '16GB',
    '32GB',
    '64GB',
  ];

  static const List<String> storageOptions = [
    '256GB',
    '512GB',
    '1TB',
    '2TB',
  ];

  static const double defaultMinPrice = 30000;
  static const double defaultMaxPrice = 1000000;
  static const double minPriceLimit = 0;
  static const double maxPriceLimit = 1000000;
}
