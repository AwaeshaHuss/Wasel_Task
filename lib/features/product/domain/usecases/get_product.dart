import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/core/usecases/usecase.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';
import 'package:wasel_task/features/product/domain/repositories/product_repository.dart';

class GetProduct extends UseCase<ProductEntity, GetProductParams> {
  final ProductRepository repository;

  GetProduct(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductParams params) async {
    return await repository.getProduct(params.id);
  }
}

class GetProductParams extends Equatable {
  final int id;

  const GetProductParams({required this.id});

  @override
  List<Object> get props => [id];
}
