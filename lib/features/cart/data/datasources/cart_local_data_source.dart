import 'package:shared_preferences/shared_preferences.dart';

abstract class CartLocalDataSource {
  Future<List<Map<String, dynamic>>> getCartItems();
  Future<void> addToCart(Map<String, dynamic> product);
  Future<void> removeFromCart(String productId);
  Future<void> updateCartItem(String productId, int quantity);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartItemsKey = 'cart_items';
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final cartItemsJson = sharedPreferences.getStringList(_cartItemsKey) ?? [];
    return cartItemsJson
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  @override
  Future<void> addToCart(Map<String, dynamic> product) async {
    final items = await getCartItems();
    final existingItemIndex = items.indexWhere((item) => item['id'] == product['id']);
    
    if (existingItemIndex >= 0) {
      // Update quantity if product already in cart
      items[existingItemIndex]['quantity'] = (items[existingItemIndex]['quantity'] ?? 1) + 1;
    } else {
      // Add new item to cart
      items.add({
        ...product,
        'quantity': 1,
      });
    }
    
    await _saveCartItems(items);
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final items = await getCartItems();
    items.removeWhere((item) => item['id'] == productId);
    await _saveCartItems(items);
  }

  @override
  Future<void> updateCartItem(String productId, int quantity) async {
    final items = await getCartItems();
    final itemIndex = items.indexWhere((item) => item['id'] == productId);
    
    if (itemIndex >= 0) {
      if (quantity > 0) {
        items[itemIndex]['quantity'] = quantity;
      } else {
        items.removeAt(itemIndex);
      }
      await _saveCartItems(items);
    }
  }

  Future<void> _saveCartItems(List<Map<String, dynamic>> items) async {
    final itemsJson = items.map((item) => item.toString()).toList();
    await sharedPreferences.setStringList(_cartItemsKey, itemsJson);
  }
}
