import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:dartz/dartz.dart';

//entity jasko parameter xa tesko lagi //SuccessType=> ReturnType
abstract interface class UsecaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

//entity jasko parameter xainw tesko lagi
abstract interface class UsecaseWithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}
