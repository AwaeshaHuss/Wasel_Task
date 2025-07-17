import 'package:dartz/dartz.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:wasel_task/features/cart/domain/repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  Future<Either<Failure, List<CartItemEntity>>> call() async {
    return await repository.getCartItems();
  }
}
