import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../local/daos/expense_dao.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDao _expenseDao;

  ExpenseRepositoryImpl(this._expenseDao);

  @override
  Future<List<Expense>> getAllExpenses() async {
    final expenses = await _expenseDao.getAllExpenses();
    return expenses.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    final expenses = await _expenseDao.getExpensesByDateRange(start, end);
    return expenses.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId) async {
    final expenses = await _expenseDao.getExpensesByCategory(categoryId);
    return expenses.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Expense?> getExpenseById(String id) async {
    final expense = await _expenseDao.getExpenseById(id);
    return expense?.toEntity();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await _expenseDao.insertExpense(expense.toCompanion());
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _expenseDao.updateExpense(expense.toCompanion());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _expenseDao.deleteExpense(id);
  }

  @override
  Future<void> deleteAllExpenses() async {
    await _expenseDao.deleteAllExpenses();
  }

  @override
  Future<double> getTotalSpending(DateTime start, DateTime end) async {
    return await _expenseDao.getTotalSpending(start, end);
  }

  @override
  Future<Map<String, double>> getCategorySpending(DateTime start, DateTime end) async {
    return await _expenseDao.getCategorySpending(start, end);
  }
}
