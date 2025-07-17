import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';

part 'product_response_model.g.dart';

@JsonSerializable()
class ProductResponseModel extends Equatable {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseModelToJson(this);

  @override
  List<Object?> get props => [products, total, skip, limit];
}
