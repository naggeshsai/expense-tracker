import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetAllExpensesUseCase {
  final ExpenseRepository repository;
  GetAllExpensesUseCase(this.repository);
  Future<List<Expense>> call() => repository.getAllExpenses();
}

class GetExpensesByDateRangeUseCase {
  final ExpenseRepository repository;
  GetExpensesByDateRangeUseCase(this.repository);
  Future<List<Expense>> call(DateTime start, DateTime end) =>
      repository.getExpensesByDateRange(start, end);
}

class GetExpensesByCategoryUseCase {
  final ExpenseRepository repository;
  GetExpensesByCategoryUseCase(this.repository);
  Future<List<Expense>> call(String categoryId) =>
      repository.getExpensesByCategory(categoryId);
}

class AddExpenseUseCase {
  final ExpenseRepository repository;
  AddExpenseUseCase(this.repository);
  Future<void> call(Expense expense) => repository.addExpense(expense);
}

class UpdateExpenseUseCase {
  final ExpenseRepository repository;
  UpdateExpenseUseCase(this.repository);
  Future<void> call(Expense expense) => repository.updateExpense(expense);
}

class DeleteExpenseUseCase {
  final ExpenseRepository repository;
  DeleteExpenseUseCase(this.repository);
  Future<void> call(String id) => repository.deleteExpense(id);
}

class GetTotalSpendingUseCase {
  final ExpenseRepository repository;
  GetTotalSpendingUseCase(this.repository);
  Future<double> call(DateTime start, DateTime end) =>
      repository.getTotalSpending(start, end);
}

class GetCategorySpendingUseCase {
  final ExpenseRepository repository;
  GetCategorySpendingUseCase(this.repository);
  Future<Map<String, double>> call(DateTime start, DateTime end) =>
      repository.getCategorySpending(start, end);
}
