part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final int? limit;
  final int? skip;

  const LoadProducts({this.limit, this.skip});

  @override
  List<Object> get props => [];
}

class LoadProductsByCategory extends ProductEvent {
  final String category;

  const LoadProductsByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

class LoadProductDetail extends ProductEvent {
  final int id;

  const LoadProductDetail(this.id);

  @override
  List<Object> get props => [id];
}

class LoadCategories extends ProductEvent {
  const LoadCategories();
}
