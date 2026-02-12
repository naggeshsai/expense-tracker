import 'package:drift/drift.dart';
import '../../domain/entities/expense.dart' as entity;
import '../local/database.dart';

extension ExpenseMapper on Expense {
  entity.Expense toEntity() {
    return entity.Expense(
      id: id,
      amount: amount,
      categoryId: categoryId,
      note: note,
      date: date,
      paymentMethod: paymentMethod,
      isRecurring: isRecurring,
      isForOther: isForOther,
      paidForPerson: paidForPerson,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }
}

extension ExpenseEntityMapper on entity.Expense {
  ExpensesCompanion toCompanion() {
    return ExpensesCompanion(
      id: Value(id),
      amount: Value(amount),
      categoryId: Value(categoryId),
      note: Value(note),
      date: Value(date),
      paymentMethod: Value(paymentMethod),
      isRecurring: Value(isRecurring),
      isForOther: Value(isForOther),
      paidForPerson: Value(paidForPerson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }
}
