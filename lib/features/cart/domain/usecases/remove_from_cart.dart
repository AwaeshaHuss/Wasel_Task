import 'package:dartz/dartz.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<Either<Failure, void>> call(String productId) async {
    try {
      await repository.removeFromCart(productId);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
