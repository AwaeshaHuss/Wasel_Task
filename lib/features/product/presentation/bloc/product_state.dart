import 'package:equatable/equatable.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final bool hasReachedMax;
  final int page;

  const ProductLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.page = 1,
  });

  ProductLoaded copyWith({
    List<ProductEntity>? products,
    bool? hasReachedMax,
    int? page,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [products, hasReachedMax, page];
}

class ProductDetailLoaded extends ProductState {
  final ProductEntity product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class CategoriesLoaded extends ProductState {
  final List<String> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
