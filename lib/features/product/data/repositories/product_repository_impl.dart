import 'package:dartz/dartz.dart';
import 'package:wasel_task/core/error/error_mapper.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/core/network/api_service_new.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';
import 'package:wasel_task/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService _apiService;

  ProductRepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int? limit,
    int? skip,
  }) async {
    try {
      final products = await _apiService.getProducts(
        limit: limit ?? 10,
        skip: skip ?? 0,
      );
      return Right(products.products.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await _apiService.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProduct(int id) async {
    try {
      final product = await _apiService.getProduct(id);
      return Right(product.toEntity());
    } catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final response = await _apiService.getProductsByCategory(category);
      return Right(response.products.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query,
  ) async {
    try {
      final response = await _apiService.searchProducts(query);
      return Right(response.products.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }
}
