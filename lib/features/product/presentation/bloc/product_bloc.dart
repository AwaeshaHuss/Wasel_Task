import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/core/usecases/usecase.dart';
import 'package:wasel_task/features/product/domain/usecases/get_categories.dart';
import 'package:wasel_task/features/product/domain/usecases/get_product.dart';
import 'package:wasel_task/features/product/domain/usecases/get_products.dart';
import 'package:wasel_task/features/product/domain/usecases/get_products_by_category.dart';
import 'package:wasel_task/features/product/domain/usecases/search_products.dart' as search_use_case;
import 'package:wasel_task/features/product/presentation/bloc/product_state.dart';

part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetProduct getProduct;
  final GetCategories getCategories;
  final GetProductsByCategory getProductsByCategory;
  final search_use_case.SearchProducts searchProducts;

  ProductBloc({
    required this.getProducts,
    required this.getProduct,
    required this.getCategories,
    required this.getProductsByCategory,
    required this.searchProducts,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductDetail>(_onLoadProductDetail);
    on<LoadCategories>(_onLoadCategories);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    
    // Don't load more if we've reached the max
    if (currentState is ProductLoaded && currentState.hasReachedMax) {
      return;
    }

    // Don't reload if we're already loading
    if (currentState is ProductLoading) {
      return;
    }

    // If we have existing products, show loading with current products
    if (currentState is ProductLoaded) {
      emit(ProductLoading(previousProducts: currentState.products));
    } else {
      emit(ProductLoading());
    }

    final failureOrProducts = await getProducts(
      limit: event.limit ?? 10,
      skip: event.skip ?? 0,
    );

    emit(
      failureOrProducts.fold(
        (failure) => ProductError(_mapFailureToMessage(failure)),
        (products) {
          if (currentState is ProductLoaded) {
            final allProducts = [...currentState.products, ...products];
            final hasReachedMax = products.length < (event.limit ?? 10);
            return currentState.copyWith(
              products: allProducts,
              hasReachedMax: hasReachedMax,
              page: currentState.page + 1,
            );
          } else {
            return ProductLoaded(
              products: products,
              hasReachedMax: products.length < (event.limit ?? 10),
              page: 1,
            );
          }
        },
      ),
    );
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final failureOrProduct = await getProduct(
      GetProductParams(id: event.id),
    );

    emit(
      failureOrProduct.fold(
        (failure) => ProductError(_mapFailureToMessage(failure)),
        (product) => ProductDetailLoaded(product),
      ),
    );
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final failureOrCategories = await getCategories(NoParams());

    emit(
      failureOrCategories.fold(
        (failure) => ProductError(_mapFailureToMessage(failure)),
        (categories) => CategoriesLoaded(categories),
      ),
    );
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final failureOrProducts = await getProductsByCategory(
      GetProductsByCategoryParams(category: event.category),
    );

    emit(
      failureOrProducts.fold(
        (failure) => ProductError(_mapFailureToMessage(failure)),
        (products) => ProductLoaded(products: products, hasReachedMax: true),
      ),
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(LoadProducts());
      return;
    }

    emit(ProductLoading());
    
    final failureOrProducts = await searchProducts(
      search_use_case.SearchProductsParams(query: event.query),
    );

    emit(
      failureOrProducts.fold(
        (failure) => ProductError(_mapFailureToMessage(failure)),
        (products) => ProductLoaded(products: products, hasReachedMax: true),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error';
      case CacheFailure:
        return 'Cache error';
      case NetworkFailure:
        return 'Network error';
      default:
        return 'Unexpected error';
    }
  }
}
