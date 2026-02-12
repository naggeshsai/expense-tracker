import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/budget.dart';
import '../../../domain/usecases/budget_usecases.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final GetAllBudgetsUseCase getAllBudgetsUseCase;
  final GetBudgetByMonthYearUseCase getBudgetByMonthYearUseCase;
  final AddBudgetUseCase addBudgetUseCase;
  final UpdateBudgetUseCase updateBudgetUseCase;
  final DeleteBudgetUseCase deleteBudgetUseCase;

  BudgetCubit({
    required this.getAllBudgetsUseCase,
    required this.getBudgetByMonthYearUseCase,
    required this.addBudgetUseCase,
    required this.updateBudgetUseCase,
    required this.deleteBudgetUseCase,
  }) : super(BudgetInitial());

  Future<void> loadBudgets() async {
    emit(BudgetLoading());
    try {
      final budgets = await getAllBudgetsUseCase();
      emit(BudgetLoaded(budgets));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<Budget?> getBudgetForMonth(int month, int year, {String? categoryId}) async {
    try {
      return await getBudgetByMonthYearUseCase(month, year, categoryId: categoryId);
    } catch (e) {
      return null;
    }
  }

  Future<void> addBudget(Budget budget) async {
    try {
      await addBudgetUseCase(budget);
      await loadBudgets();
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      await updateBudgetUseCase(budget);
      await loadBudgets();
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      await deleteBudgetUseCase(id);
      await loadBudgets();
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }
}
