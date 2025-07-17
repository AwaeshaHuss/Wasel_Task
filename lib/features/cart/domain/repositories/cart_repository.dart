import 'package:dartz/dartz.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();
  
  Future<Either<Failure, Unit>> addToCart(ProductEntity product, {int quantity = 1});
  
  Future<Either<Failure, Unit>> removeFromCart(String productId);
  
  Future<Either<Failure, Unit>> updateQuantity(String productId, int quantity);
  
  Future<Either<Failure, Unit>> clearCart();
  
  Future<Either<Failure, int>> getItemCount(String productId);
  
  Future<Either<Failure, double>> getTotalPrice();
}
