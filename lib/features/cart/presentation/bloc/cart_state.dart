import 'package:equatable/equatable.dart';
import 'package:wasel_task/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  final double totalPrice;
  final int totalItems;

  const CartLoaded({
    required this.items,
    required this.totalPrice,
    required this.totalItems,
  });

  @override
  List<Object> get props => [items, totalPrice, totalItems];
}

class CartItemCountLoaded extends CartState {
  final int count;

  const CartItemCountLoaded(this.count);

  @override
  List<Object> get props => [count];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

class CartOperationSuccess extends CartState {
  final String message;

  const CartOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
