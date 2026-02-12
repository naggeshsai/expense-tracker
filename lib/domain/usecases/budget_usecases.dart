import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class GetAllBudgetsUseCase {
  final BudgetRepository repository;
  GetAllBudgetsUseCase(this.repository);
  Future<List<Budget>> call() => repository.getAllBudgets();
}

class GetBudgetByIdUseCase {
  final BudgetRepository repository;
  GetBudgetByIdUseCase(this.repository);
  Future<Budget?> call(String id) => repository.getBudgetById(id);
}

class GetBudgetByMonthYearUseCase {
  final BudgetRepository repository;
  GetBudgetByMonthYearUseCase(this.repository);
  Future<Budget?> call(int month, int year, {String? categoryId}) =>
      repository.getBudgetByMonthYear(month, year, categoryId: categoryId);
}

class AddBudgetUseCase {
  final BudgetRepository repository;
  AddBudgetUseCase(this.repository);
  Future<void> call(Budget budget) => repository.addBudget(budget);
}

class UpdateBudgetUseCase {
  final BudgetRepository repository;
  UpdateBudgetUseCase(this.repository);
  Future<void> call(Budget budget) => repository.updateBudget(budget);
}

class DeleteBudgetUseCase {
  final BudgetRepository repository;
  DeleteBudgetUseCase(this.repository);
  Future<void> call(String id) => repository.deleteBudget(id);
}
