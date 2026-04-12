import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Product model using freezed for immutability and json_serializable for JSON
@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    required String description,
    required double price,
    required String currency,
    String? imageUrl,
    required DateTime createdAt,
    @Default([]) List<String> tags,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
