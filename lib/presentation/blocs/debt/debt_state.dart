import 'package:equatable/equatable.dart';
import '../../../domain/entities/person_debt.dart';
import '../../../domain/entities/expense.dart';

abstract class DebtState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DebtInitial extends DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  final List<PersonDebt> debts;

  DebtLoaded(this.debts);

  @override
  List<Object?> get props => [debts];
}

class DebtPersonExpensesLoaded extends DebtState {
  final String personName;
  final List<Expense> expenses;
  final double totalOwed;

  DebtPersonExpensesLoaded({
    required this.personName,
    required this.expenses,
    required this.totalOwed,
  });

  @override
  List<Object?> get props => [personName, expenses, totalOwed];
}

class DebtError extends DebtState {
  final String message;

  DebtError(this.message);

  @override
  List<Object?> get props => [message];
}
