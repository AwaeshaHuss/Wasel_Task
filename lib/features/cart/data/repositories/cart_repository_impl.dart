import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasel_task/core/error/exceptions.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/cart/data/models/cart_item_model.dart';
import 'package:wasel_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:wasel_task/features/cart/domain/repositories/cart_repository.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';

class CartRepositoryImpl implements CartRepository {
  static const String _cartKey = 'cart_items';
  final SharedPreferences _prefs;

  CartRepositoryImpl(this._prefs);

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final jsonString = _prefs.getString(_cartKey);
      if (jsonString == null || jsonString.isEmpty) {
        return const Right([]);
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      final items = jsonList
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();
      
      return Right(items);
    } on Exception catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addToCart(ProductEntity product, {int quantity = 1}) async {
    try {
      final currentItems = await getCartItems();
      return await currentItems.fold(
        (failure) => Left(failure),
        (items) async {
          final index = items.indexWhere((item) => item.product.id == product.id);
          
          if (index != -1) {
            // Update existing item
            final updatedItem = items[index].copyWith(
              quantity: (items[index].quantity + quantity).clamp(1, 100),
            );
            items[index] = updatedItem;
          } else {
            // Add new item
            items.add(CartItemEntity(
              product: product,
              quantity: quantity.clamp(1, 100),
            ));
          }

          // Save to SharedPreferences
          final jsonList = items
              .map((item) => CartItemModel.fromEntity(item).toJson())
              .toList();
          await _prefs.setString(_cartKey, json.encode(jsonList));
          
          return const Right(unit);
        },
      );
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromCart(String productId) async {
    try {
      final currentItems = await getCartItems();
      return await currentItems.fold(
        (failure) => Left(failure),
        (items) async {
          items.removeWhere((item) => item.product.id == productId);
          
          // Save updated list to SharedPreferences
          final jsonList = items
              .map((item) => CartItemModel.fromEntity(item).toJson())
              .toList();
          await _prefs.setString(_cartKey, json.encode(jsonList));
          
          return const Right(unit);
        },
      );
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateQuantity(String productId, int quantity) async {
    try {
      final currentItems = await getCartItems();
      return await currentItems.fold(
        (failure) => Left(failure),
        (items) async {
          final index = items.indexWhere((item) => item.product.id == productId);
          
          if (index != -1) {
            final updatedItem = items[index].copyWith(
              quantity: quantity.clamp(1, 100),
            );
            items[index] = updatedItem;
            
            // Save updated list to SharedPreferences
            final jsonList = items
                .map((item) => CartItemModel.fromEntity(item).toJson())
                .toList();
            await _prefs.setString(_cartKey, json.encode(jsonList));
          }
          
          return const Right(unit);
        },
      );
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      await _prefs.remove(_cartKey);
      return const Right(unit);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getItemCount(String productId) async {
    try {
      final currentItems = await getCartItems();
      return currentItems.fold(
        (failure) => Left(failure),
        (items) {
          final item = items.firstWhere(
            (item) => item.product.id == productId,
            orElse: () => CartItemEntity(
              product: ProductEntity(
                id: 0,
                title: '',
                name: '',
                description: '',
                price: 0,
                discountPercentage: 0,
                rating: 0,
                stock: 0,
                brand: '',
                category: '',
                thumbnail: '',
                images: [],
              ),
              quantity: 0,
            ),
          );
          return Right(item.quantity);
        },
      );
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getTotalPrice() async {
    try {
      final currentItems = await getCartItems();
      return currentItems.fold(
        (failure) => Left(failure),
        (items) {
          final total = items.fold<double>(
            0,
            (sum, item) => sum + item.totalPriceAfterDiscount,
          );
          return Right(total);
        },
      );
    } on Exception {
      return Left(CacheFailure());
    }
  }
}