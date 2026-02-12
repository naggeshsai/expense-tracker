import '../../../domain/entities/expense.dart';

abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class LoadExpensesByDateRange extends ExpenseEvent {
  final DateTime start;
  final DateTime end;
  LoadExpensesByDateRange(this.start, this.end);
}

class LoadExpensesByCategory extends ExpenseEvent {
  final String categoryId;
  LoadExpensesByCategory(this.categoryId);
}

class AddExpense extends ExpenseEvent {
  final Expense expense;
  AddExpense(this.expense);
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;
  UpdateExpense(this.expense);
}

class DeleteExpense extends ExpenseEvent {
  final String id;
  DeleteExpense(this.id);
}

class DeleteAllExpenses extends ExpenseEvent {}
