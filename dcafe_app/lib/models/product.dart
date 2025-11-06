import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: 'product_id')
  final String id;

  @JsonKey(name: 'product_name')
  final String name;

  @JsonKey(name: 'product_price')
  final String price; // Poster API returns price as string

  @JsonKey(name: 'category_id')
  final String categoryId;

  @JsonKey(name: 'product_production_description')
  final String? description;

  @JsonKey(name: 'photo')
  final String? photoUrl;

  @JsonKey(name: 'photo_origin')
  final String? photoOriginUrl;

  @JsonKey(name: 'visible')
  final String visible; // "1" = visible, "0" = hidden

  @JsonKey(name: 'product_tax_id')
  final String? taxId;

  @JsonKey(name: 'out')
  final String outOfStock; // "0" = in stock, "1" = out of stock

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    this.description,
    this.photoUrl,
    this.photoOriginUrl,
    this.visible = "1",
    this.taxId,
    this.outOfStock = "0",
  });

  double get priceValue => double.tryParse(price) ?? 0.0;
  bool get isVisible => visible == "1";
  bool get isAvailable => outOfStock == "0";
  String get imageUrl => photoOriginUrl ?? photoUrl ?? '';

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
