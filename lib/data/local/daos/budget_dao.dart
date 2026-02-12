import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/budget_table.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [Budgets])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(AppDatabase db) : super(db);

  Future<List<Budget>> getAllBudgets() => select(budgets).get();

  Future<Budget?> getBudgetById(String id) {
    return (select(budgets)..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  Future<Budget?> getBudgetByMonthYear(int month, int year, {String? categoryId}) {
    final query = select(budgets)
      ..where((b) => b.month.equals(month) & b.year.equals(year));
    
    if (categoryId != null) {
      query.where((b) => b.categoryId.equals(categoryId));
    } else {
      query.where((b) => b.categoryId.isNull());
    }
    
    return query.getSingleOrNull();
  }

  Future<int> insertBudget(BudgetsCompanion budget) {
    return into(budgets).insert(budget);
  }

  Future<bool> updateBudget(BudgetsCompanion budget) {
    return update(budgets).replace(budget);
  }

  Future<int> deleteBudget(String id) {
    return (delete(budgets)..where((b) => b.id.equals(id))).go();
  }
}
