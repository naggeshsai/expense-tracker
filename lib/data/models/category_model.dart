import 'package:drift/drift.dart';
import '../../domain/entities/category.dart' as entity;
import '../local/database.dart';

extension CategoryMapper on Category {
  entity.Category toEntity() {
    return entity.Category(
      id: id,
      name: name,
      icon: icon,
      color: color,
      isCustom: isCustom,
      createdAt: createdAt,
    );
  }
}

extension CategoryEntityMapper on entity.Category {
  CategoriesCompanion toCompanion() {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      isCustom: Value(isCustom),
      createdAt: Value(createdAt),
    );
  }
}
