import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses();
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end);
  Future<List<Expense>> getExpensesByCategory(String categoryId);
  Future<Expense?> getExpenseById(String id);
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<void> deleteAllExpenses();
  Future<double> getTotalSpending(DateTime start, DateTime end);
  Future<Map<String, double>> getCategorySpending(DateTime start, DateTime end);
}
