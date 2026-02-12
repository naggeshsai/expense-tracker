import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getAllBudgets();
  Future<Budget?> getBudgetByMonthYear(int month, int year, {String? categoryId});
  Future<Budget?> getBudgetById(String id);
  Future<void> addBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(String id);
}
