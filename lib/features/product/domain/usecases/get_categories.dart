import 'package:dartz/dartz.dart';
import 'package:wasel_task/core/error/failures.dart';
import 'package:wasel_task/core/usecases/usecase.dart';
import 'package:wasel_task/features/product/domain/repositories/product_repository.dart';

class GetCategories extends UseCase<List<String>, NoParams> {
  final ProductRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
