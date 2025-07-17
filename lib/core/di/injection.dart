import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
  
// Core
import 'package:wasel_task/core/network/api_service_new.dart';
import 'package:wasel_task/core/network/http_client_wrapper.dart';

// Features - Cart
import 'package:wasel_task/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:wasel_task/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:wasel_task/features/cart/domain/repositories/cart_repository.dart';
import 'package:wasel_task/features/cart/domain/usecases/add_to_cart.dart';
import 'package:wasel_task/features/cart/domain/usecases/get_cart_items.dart';
import 'package:wasel_task/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:wasel_task/features/cart/domain/usecases/update_cart_item.dart';
import 'package:wasel_task/features/cart/presentation/bloc/cart_bloc.dart' hide AddToCart, RemoveFromCart;

// Features - Product
import 'package:wasel_task/features/product/data/datasources/product_remote_data_source.dart';
import 'package:wasel_task/features/product/data/repositories/product_repository_impl.dart';
import 'package:wasel_task/features/product/domain/repositories/product_repository.dart';
import 'package:wasel_task/features/product/domain/usecases/get_categories.dart';
import 'package:wasel_task/features/product/domain/usecases/get_product.dart';
import 'package:wasel_task/features/product/domain/usecases/get_products.dart';
import 'package:wasel_task/features/product/domain/usecases/get_products_by_category.dart';
import 'package:wasel_task/features/product/domain/usecases/search_products.dart';
import 'package:wasel_task/features/product/presentation/bloc/product_bloc.dart' hide SearchProducts;

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Register external dependencies
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<ApiService>(
    ApiService(HttpClientWrapper(baseUrl: 'https://dummyjson.com', client: http.Client())),
  );
  
  // Data sources
  getIt.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: getIt()),
  );
  
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiService: getIt()),
  );
  
  // Repositories
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(getIt()),
  );
  
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );
  
  // Use cases - Cart
  getIt.registerLazySingleton(() => GetCartItems(getIt()));
  getIt.registerLazySingleton(() => AddToCart(getIt()));
  getIt.registerLazySingleton(() => RemoveFromCart(getIt()));
  getIt.registerLazySingleton(() => UpdateCartItem(getIt()));
  
  // Use cases - Product
  getIt.registerLazySingleton(() => GetProducts(getIt()));
  getIt.registerLazySingleton(() => GetProduct(getIt()));
  getIt.registerLazySingleton(() => GetCategories(getIt()));
  getIt.registerLazySingleton(() => GetProductsByCategory(getIt()));
  getIt.registerLazySingleton(() => SearchProducts(getIt()));
  
  // BLoCs
  getIt.registerFactory(
    () => CartBloc(getIt<CartRepository>(), getCartItems: getIt()),
  );
  
  getIt.registerFactory(
    () => ProductBloc(
      getProducts: getIt(),
      getProduct: getIt(),
      getCategories: getIt(),
      getProductsByCategory: getIt(),
      searchProducts: getIt(),
    ),
  );
  
  // Register Firebase if needed
  // await Firebase.initializeApp();
}
