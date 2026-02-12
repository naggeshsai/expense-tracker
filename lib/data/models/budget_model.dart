import 'package:drift/drift.dart';
import '../../domain/entities/budget.dart' as entity;
import '../local/database.dart';

extension BudgetMapper on Budget {
  entity.Budget toEntity() {
    return entity.Budget(
      id: id,
      categoryId: categoryId,
      amount: amount,
      month: month,
      year: year,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension BudgetEntityMapper on entity.Budget {
  BudgetsCompanion toCompanion() {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      amount: Value(amount),
      month: Value(month),
      year: Value(year),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
