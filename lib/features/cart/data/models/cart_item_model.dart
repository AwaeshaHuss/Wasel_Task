import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wasel_task/features/product/data/models/product_model.dart';
import 'package:wasel_task/features/cart/domain/entities/cart_item_entity.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItemEntity toEntity() {
    return CartItemEntity(
      product: product.toEntity(),
      quantity: quantity,
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      product: ProductModel.fromEntity(entity.product),
      quantity: entity.quantity,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];
  
}
