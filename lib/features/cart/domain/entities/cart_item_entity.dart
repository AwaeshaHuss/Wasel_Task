import 'package:equatable/equatable.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
  double get totalPriceAfterDiscount => product.priceAfterDiscount * quantity;

  CartItemEntity copyWith({
    ProductEntity? product,
    int? quantity,
  }) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];
}
