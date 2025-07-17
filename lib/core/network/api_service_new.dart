import 'package:wasel_task/core/network/http_client_wrapper.dart';
import 'package:wasel_task/features/product/data/models/product_model.dart';
import 'package:wasel_task/features/product/data/models/product_response_model.dart';

class ApiService {
  final HttpClientWrapper _httpClient;
  final String baseUrl;

  ApiService(this._httpClient, {this.baseUrl = 'https://dummyjson.com'});

  // Products
  Future<ProductResponseModel> getProducts({
    int limit = 10,
    int skip = 0,
    String? select,
    String? query,
  }) async {
    final params = {
      'limit': limit,
      'skip': skip,
      if (select != null) 'select': select,
      if (query != null) 'q': query,
    };
    
    final response = await _httpClient.get(
      '/products',
      queryParameters: params,
    );
    
    return ProductResponseModel.fromJson(response);
  }

  // Get single product
  Future<ProductModel> getProduct(int id) async {
    final response = await _httpClient.get('/products/$id');
    return ProductModel.fromJson(response);
  }

  // Get all categories
  Future<List<String>> getCategories() async {
    final response = await _httpClient.get('/products/categories');
    return List<String>.from(response);
  }

  // Get products by category
  Future<ProductResponseModel> getProductsByCategory(String category) async {
    final response = await _httpClient.get('/products/category/$category');
    return ProductResponseModel.fromJson(response);
  }

  // Search products
  Future<ProductResponseModel> searchProducts(String query) async {
    final response = await _httpClient.get(
      '/products/search',
      queryParameters: {'q': query},
    );
    return ProductResponseModel.fromJson(response);
  }
}
