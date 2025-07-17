import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:wasel_task/features/cart/domain/repositories/cart_repository.dart';
import 'package:wasel_task/features/cart/presentation/bloc/cart_state.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';

part 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository, {required Object getCartItems}) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<GetCartItemCount>(_onGetCartItemCount);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    
    final result = await _cartRepository.getCartItems();
    
    result.fold(
      (failure) => emit(CartError(_mapFailureToMessage(failure))),
      (items) => emit(
        CartLoaded(
          items: items,
          totalPrice: items.fold(
            0,
            (sum, item) => sum + item.totalPriceAfterDiscount,
          ),
          totalItems: items.fold(
            0,
            (sum, item) => sum + item.quantity,
          ),
        ),
      ),
    );
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final result = await _cartRepository.addToCart(
      event.product,
      quantity: event.quantity,
    );

    await result.fold(
      (failure) async {
        emit(CartError(_mapFailureToMessage(failure)));
      },
      (_) async {
        emit(const CartOperationSuccess('Product added to cart'));
        add(LoadCart());
      },
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    final result = await _cartRepository.removeFromCart(event.productId);

    await result.fold(
      (failure) async {
        emit(CartError(_mapFailureToMessage(failure)));
      },
      (_) async {
        emit(const CartOperationSuccess('Product removed from cart'));
        add(LoadCart());
      },
    );
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    final result = await _cartRepository.updateQuantity(
      event.productId,
      event.quantity,
    );

    await result.fold(
      (failure) async {
        emit(CartError(_mapFailureToMessage(failure)));
      },
      (_) async {
        emit(const CartOperationSuccess('Cart updated'));
        add(LoadCart());
      },
    );
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final result = await _cartRepository.clearCart();

    await result.fold(
      (failure) async {
        emit(CartError(_mapFailureToMessage(failure)));
      },
      (_) async {
        emit(const CartOperationSuccess('Cart cleared'));
        add(LoadCart());
      },
    );
  }

  Future<void> _onGetCartItemCount(
    GetCartItemCount event,
    Emitter<CartState> emit,
  ) async {
    final result = await _cartRepository.getItemCount(event.productId);

    result.fold(
      (failure) => emit(CartError(_mapFailureToMessage(failure))),
      (count) => emit(CartItemCountLoaded(count)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return 'Failed to access cart storage';
      default:
        return 'An unexpected error occurred';
    }
  }
}
