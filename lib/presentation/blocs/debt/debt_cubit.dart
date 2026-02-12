import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/person_debt.dart';
import '../../../domain/usecases/expense_usecases.dart';
import 'debt_state.dart';

class DebtCubit extends Cubit<DebtState> {
  final GetDebtsByPersonUseCase getDebtsByPersonUseCase;
  final GetExpensesByPersonUseCase getExpensesByPersonUseCase;

  DebtCubit({
    required this.getDebtsByPersonUseCase,
    required this.getExpensesByPersonUseCase,
  }) : super(DebtInitial());

  Future<void> loadDebts() async {
    emit(DebtLoading());
    try {
      final debtsMap = await getDebtsByPersonUseCase();
      final debts = debtsMap.entries
          .map((e) => PersonDebt(personName: e.key, totalOwed: e.value))
          .toList()
        ..sort((a, b) => b.totalOwed.compareTo(a.totalOwed));
      emit(DebtLoaded(debts));
    } catch (e) {
      emit(DebtError(e.toString()));
    }
  }

  Future<void> loadExpensesForPerson(String personName) async {
    emit(DebtLoading());
    try {
      final expenses = await getExpensesByPersonUseCase(personName);
      double total = 0;
      for (final expense in expenses) {
        total += expense.amount;
      }
      emit(DebtPersonExpensesLoaded(
        personName: personName,
        expenses: expenses,
        totalOwed: total,
      ));
    } catch (e) {
      emit(DebtError(e.toString()));
    }
  }
}
