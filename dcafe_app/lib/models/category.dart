import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  @JsonKey(name: 'category_id')
  final String id;

  @JsonKey(name: 'category_name')
  final String name;

  @JsonKey(name: 'category_photo')
  final String? photoUrl;

  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @JsonKey(name: 'category_hidden')
  final int hidden; // 0 = visible, 1 = hidden

  Category({
    required this.id,
    required this.name,
    this.photoUrl,
    this.sortOrder = 0,
    this.hidden = 0,
  });

  bool get isVisible => hidden == 0;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
