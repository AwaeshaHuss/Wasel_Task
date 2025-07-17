import 'package:dartz/dartz.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int? limit,
    int? skip,
  });

  Future<Either<Failure, List<String>>> getCategories();

  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String category,
  );

  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);

  Future<Either<Failure, ProductEntity>> getProduct(int id);
}
