import 'package:dartz/dartz.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartItem {
  final CartRepository repository;

  UpdateCartItem(this.repository);

  Future<Either<Failure, void>> call(String productId, int quantity) async {
    try {
      await repository.updateQuantity(productId, quantity);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
