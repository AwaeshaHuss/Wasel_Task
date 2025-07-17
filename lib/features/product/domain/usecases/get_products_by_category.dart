import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/core/usecases/usecase.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';
import 'package:wasel_task/features/product/domain/repositories/product_repository.dart';

class GetProductsByCategory implements UseCase<List<ProductEntity>, GetProductsByCategoryParams> {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
      GetProductsByCategoryParams params) async {
    return await repository.getProductsByCategory(params.category);
  }
}

class GetProductsByCategoryParams extends Equatable {
  final String category;

  const GetProductsByCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
