import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int color;
  final bool isCustom;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isCustom,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, icon, color, isCustom, createdAt];

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
    bool? isCustom,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
