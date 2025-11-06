// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['category_id'] as String,
      name: json['category_name'] as String,
      photoUrl: json['category_photo'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      hidden: json['category_hidden'] as int? ?? 0,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'category_id': instance.id,
      'category_name': instance.name,
      'category_photo': instance.photoUrl,
      'sort_order': instance.sortOrder,
      'category_hidden': instance.hidden,
    };
