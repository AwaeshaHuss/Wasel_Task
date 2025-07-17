import 'package:dartz/dartz.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/cart/domain/repositories/cart_repository.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<Either<Failure, void>> call(ProductEntity product) async {
    try {
      await repository.addToCart(product);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
