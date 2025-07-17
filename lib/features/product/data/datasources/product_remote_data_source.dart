import 'package:wasel_task/core/network/api_service_new.dart';
import 'package:wasel_task/features/product/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit, int skip});
  Future<ProductModel> getProductDetail(int id);
  Future<List<String>> getCategories();
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;
  
  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ProductModel>> getProducts({int? limit, int? skip}) async {
    try {
      final response = await apiService.getProducts(
        limit: limit ?? 10, // Provide default values
        skip: skip ?? 0,    // Provide default values
      );
      return response.products.map((product) => ProductModel.fromJson(product.toJson())).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Future<ProductModel> getProductDetail(int id) async {
    try {
      final response = await apiService.getProduct(id);
      return ProductModel.fromJson(response.toJson());
    } catch (e) {
      throw Exception('Failed to load product details: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await apiService.getCategories();
      return List<String>.from(response);
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await apiService.getProductsByCategory(category);
      return response.products.map((product) => ProductModel.fromJson(product.toJson())).toList();
    } catch (e) {
      throw Exception('Failed to load products by category: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await apiService.searchProducts(query);
      // Return ProductModel list, not entity list
      return response.products.map((product) => ProductModel.fromJson(product.toJson())).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
}