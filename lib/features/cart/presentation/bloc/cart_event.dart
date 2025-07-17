part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final ProductEntity product;
  final int quantity;

  const AddToCart(this.product, {this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}

class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantity(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}

class GetCartItemCount extends CartEvent {
  final String productId;

  const GetCartItemCount(this.productId);

  @override
  List<Object> get props => [productId];
}
