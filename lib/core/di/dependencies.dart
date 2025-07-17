import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Core
import 'package:wasel_task/core/network/http_client_wrapper.dart';
import 'package:wasel_task/core/network/api_service_new.dart' as new_api_service;

// Cart
import 'package:wasel_task/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:wasel_task/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:wasel_task/features/cart/domain/repositories/cart_repository.dart';
import 'package:wasel_task/features/cart/domain/usecases/add_to_cart.dart' as add_to_cart_usecase;
import 'package:wasel_task/features/cart/domain/usecases/get_cart_items.dart';
import 'package:wasel_task/features/cart/domain/usecases/remove_from_cart.dart' as remove_from_cart_usecase;
import 'package:wasel_task/features/cart/domain/usecases/update_cart_item.dart';
import 'package:wasel_task/features/cart/presentation/bloc/cart_bloc.dart' as cart_bloc;

// Product
import 'package:wasel_task/features/product/data/datasources/product_remote_data_source.dart';
import 'package:wasel_task/features/product/data/repositories/product_repository_impl.dart';
import 'package:wasel_task/features/product/domain/repositories/product_repository.dart';
import 'package:wasel_task/features/product/domain/usecases/get_categories.dart';
import 'package:wasel_task/features/product/domain/usecases/get_product.dart';
import 'package:wasel_task/features/product/domain/usecases/get_products.dart';
import 'package:wasel_task/features/product/domain/usecases/get_products_by_category.dart';
import 'package:wasel_task/features/product/domain/usecases/search_products.dart' as search_products_usecase;
import 'package:wasel_task/features/product/presentation/bloc/product_bloc.dart';

/// A container for all dependencies used throughout the app.
/// This serves as a manual dependency injection container.
class Dependencies {
  // External dependencies
  late final SharedPreferences sharedPreferences;
  late final http.Client httpClient;
  late final HttpClientWrapper httpClientWrapper;
  late final new_api_service.ApiService apiService;

  // Data sources
  late final CartLocalDataSource cartLocalDataSource;
  late final ProductRemoteDataSource productRemoteDataSource;

  // Repositories
  late final CartRepository cartRepository;
  late final ProductRepository productRepository;

  // Use cases - Cart
  late final GetCartItems getCartItems;
  late final add_to_cart_usecase.AddToCart addToCart;
  late final remove_from_cart_usecase.RemoveFromCart removeFromCart;
  late final UpdateCartItem updateCartItem;

  // Use cases - Product
  late final GetProducts getProducts;
  late final GetProduct getProduct;
  late final GetCategories getCategories;
  late final GetProductsByCategory getProductsByCategory;
  late final search_products_usecase.SearchProducts searchProducts;

  // BLoCs
  late final cart_bloc.CartBloc cartBloc;
  late final ProductBloc productBloc;

  /// Initializes all dependencies.
  /// This should be called before the app starts.
  static Future<Dependencies> initialize() async {
    final dependencies = Dependencies._();
    await dependencies._initialize();
    return dependencies;
  }

  Dependencies._();

  Future<void> _initialize() async {
    // Initialize external services
    sharedPreferences = await SharedPreferences.getInstance();
    httpClient = http.Client();
    
    // Initialize HTTP client and API service
    httpClientWrapper = HttpClientWrapper(
      baseUrl: 'https://dummyjson.com',
      client: httpClient,
    );
    
    apiService = new_api_service.ApiService(httpClientWrapper);

    // Initialize data sources with named parameters
    cartLocalDataSource = CartLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    productRemoteDataSource = ProductRemoteDataSourceImpl(apiService: apiService);

    // Initialize repositories with required parameters
    // Note: CartRepositoryImpl expects SharedPreferences, not CartLocalDataSource
    // For now, we'll pass SharedPreferences directly, but we should refactor to use the data source
    cartRepository = CartRepositoryImpl(sharedPreferences);
    productRepository = ProductRepositoryImpl(apiService);

    // Initialize use cases - Cart
    getCartItems = GetCartItems(cartRepository);
    addToCart = add_to_cart_usecase.AddToCart(cartRepository);
    removeFromCart = remove_from_cart_usecase.RemoveFromCart(cartRepository);
    updateCartItem = UpdateCartItem(cartRepository);

    // Initialize use cases - Product
    getProducts = GetProducts(productRepository);
    getProduct = GetProduct(productRepository);
    getCategories = GetCategories(productRepository);
    getProductsByCategory = GetProductsByCategory(productRepository);
    searchProducts = search_products_usecase.SearchProducts(productRepository);

    // Initialize BLoCs
    cartBloc = cart_bloc.CartBloc(cartRepository, getCartItems: getCartItems);
    
    productBloc = ProductBloc(
      getProducts: getProducts,
      getCategories: getCategories,
      searchProducts: searchProducts,
      getProduct: getProduct,
      getProductsByCategory: getProductsByCategory,
    );
  }

  /// Disposes of all resources that need to be cleaned up.
  void dispose() {
    cartBloc.close();
    productBloc.close();
    httpClient.close();
    httpClientWrapper.close();
  }
}

/// Global instance of dependencies.
/// This should be initialized in main.dart before running the app.
Dependencies? _dependencies;

/// Gets the global dependencies instance.
/// Throws if [initializeDependencies] hasn't been called.
Dependencies get dependencies {
  if (_dependencies == null) {
    throw StateError('Dependencies have not been initialized. '
        'Call initializeDependencies() before accessing dependencies.');
  }
  return _dependencies!;
}

/// Initializes global dependencies.
/// This should be called before running the app.
Future<void> initializeDependencies() async {
  _dependencies = await Dependencies.initialize();
}

/// Disposes of global dependencies.
/// This should be called when the app is shutting down.
void disposeDependencies() {
  _dependencies?.dispose();
  _dependencies = null;
}
