import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends ProductEntity {
  const ProductModel({
    required int id,
    required String title,
    required String description,
    required double price,
    @JsonKey(name: 'discountPercentage') required double discountPercentage,
    required double rating,
    required int stock,
    required String brand,
    required String category,
    required String thumbnail,
    required List<String> images,
  }) : super(
          id: id,
          name: title,
          title: title,
          description: description,
          price: price,
          discountPercentage: discountPercentage,
          rating: rating,
          stock: stock,
          brand: brand,
          category: category,
          thumbnail: thumbnail,
          images: images,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      discountPercentage: entity.discountPercentage,
      rating: entity.rating,
      stock: entity.stock,
      brand: entity.brand,
      category: entity.category,
      thumbnail: entity.thumbnail,
      images: List<String>.from(entity.images),
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: title,
      title: title,
      description: description,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      brand: brand,
      category: category,
      thumbnail: thumbnail,
      images: images,
    );
  }
}
