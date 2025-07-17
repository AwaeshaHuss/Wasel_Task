import 'package:wasel_task/features/product/domain/repositories/product_repository.dart';
import 'package:wasel_task/features/product/domain/usecases/get_categories.dart';
import 'package:wasel_task/features/product/domain/usecases/get_product.dart';
import 'package:wasel_task/features/product/domain/usecases/get_products.dart';
import 'package:wasel_task/features/product/domain/usecases/get_products_by_category.dart';

abstract class UseCaseModule {
  // Product Use Cases
  GetProducts getProducts(ProductRepository repository) => GetProducts(repository);

  GetProduct getProduct(ProductRepository repository) => GetProduct(repository);

  GetCategories getCategories(ProductRepository repository) =>
      GetCategories(repository);

  GetProductsByCategory getProductsByCategory(ProductRepository repository) =>
      GetProductsByCategory(repository);

  // SearchProducts is automatically registered via @injectable annotation

  // Auth Use Cases would be registered here if they were extracted
  
  // Cart Use Cases would be registered here if they were extracted
}
