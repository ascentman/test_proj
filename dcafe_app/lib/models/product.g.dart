// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['product_id'] as String,
      name: json['product_name'] as String,
      price: json['product_price'] as String,
      categoryId: json['category_id'] as String,
      description: json['product_production_description'] as String?,
      photoUrl: json['photo'] as String?,
      photoOriginUrl: json['photo_origin'] as String?,
      visible: json['visible'] as String? ?? "1",
      taxId: json['product_tax_id'] as String?,
      outOfStock: json['out'] as String? ?? "0",
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'product_id': instance.id,
      'product_name': instance.name,
      'product_price': instance.price,
      'category_id': instance.categoryId,
      'product_production_description': instance.description,
      'photo': instance.photoUrl,
      'photo_origin': instance.photoOriginUrl,
      'visible': instance.visible,
      'product_tax_id': instance.taxId,
      'out': instance.outOfStock,
    };
