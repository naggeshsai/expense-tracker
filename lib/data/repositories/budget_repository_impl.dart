import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../local/daos/budget_dao.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetDao _budgetDao;

  BudgetRepositoryImpl(this._budgetDao);

  @override
  Future<List<Budget>> getAllBudgets() async {
    final budgets = await _budgetDao.getAllBudgets();
    return budgets.map((b) => b.toEntity()).toList();
  }

  @override
  Future<Budget?> getBudgetById(String id) async {
    final budget = await _budgetDao.getBudgetById(id);
    return budget?.toEntity();
  }

  @override
  Future<Budget?> getBudgetByMonthYear(int month, int year, {String? categoryId}) async {
    final budget = await _budgetDao.getBudgetByMonthYear(month, year, categoryId: categoryId);
    return budget?.toEntity();
  }

  @override
  Future<void> addBudget(Budget budget) async {
    await _budgetDao.insertBudget(budget.toCompanion());
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    await _budgetDao.updateBudget(budget.toCompanion());
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _budgetDao.deleteBudget(id);
  }
}
