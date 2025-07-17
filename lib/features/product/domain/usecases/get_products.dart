import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';
import 'package:wasel_task/features/product/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    int limit = 10,
    int skip = 0,
  }) async {
    return await repository.getProducts(limit: limit, skip: skip);
  }
}

class GetProductsParams extends Equatable {
  final int? limit;
  final int? skip;

  const GetProductsParams({this.limit, this.skip});

  @override
  List<Object?> get props => [limit, skip];
}
