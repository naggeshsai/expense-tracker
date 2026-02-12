import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/expense_table.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(AppDatabase db) : super(db);

  Future<List<Expense>> getAllExpenses() => select(expenses).get();

  Future<Expense?> getExpenseById(String id) {
    return (select(expenses)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) {
    return (select(expenses)
          ..where((e) => e.date.isBetweenValues(start, end))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .get();
  }

  Future<List<Expense>> getExpensesByCategory(String categoryId) {
    return (select(expenses)
          ..where((e) => e.categoryId.equals(categoryId))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .get();
  }

  Future<int> insertExpense(ExpensesCompanion expense) {
    return into(expenses).insert(expense);
  }

  Future<bool> updateExpense(ExpensesCompanion expense) {
    return update(expenses).replace(expense);
  }

  Future<int> deleteExpense(String id) {
    return (delete(expenses)..where((e) => e.id.equals(id))).go();
  }

  Future<int> deleteAllExpenses() {
    return delete(expenses).go();
  }

  Future<double> getTotalSpending(DateTime start, DateTime end) async {
    final query = selectOnly(expenses)
      ..addColumns([expenses.amount.sum()])
      ..where(expenses.date.isBetweenValues(start, end));
    
    final result = await query.getSingleOrNull();
    return result?.read(expenses.amount.sum()) ?? 0.0;
  }

  Future<Map<String, double>> getCategorySpending(DateTime start, DateTime end) async {
    final query = selectOnly(expenses)
      ..addColumns([expenses.categoryId, expenses.amount.sum()])
      ..where(expenses.date.isBetweenValues(start, end))
      ..groupBy([expenses.categoryId]);
    
    final results = await query.get();
    final spending = <String, double>{};
    
    for (final row in results) {
      final categoryId = row.read(expenses.categoryId);
      final total = row.read(expenses.amount.sum()) ?? 0.0;
      if (categoryId != null) {
        spending[categoryId] = total;
      }
    }
    
    return spending;
  }

  /// Get all expenses that were paid for other people
  Future<List<Expense>> getExpensesForOthers() {
    return (select(expenses)
          ..where((e) => e.isForOther.equals(true))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .get();
  }

  /// Get expenses paid for a specific person
  Future<List<Expense>> getExpensesByPerson(String personName) {
    return (select(expenses)
          ..where((e) =>
              e.isForOther.equals(true) &
              e.paidForPerson.equals(personName))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .get();
  }

  /// Get total owed per person (aggregated)
  Future<Map<String, double>> getDebtsByPerson() async {
    final query = selectOnly(expenses)
      ..addColumns([expenses.paidForPerson, expenses.amount.sum()])
      ..where(expenses.isForOther.equals(true))
      ..groupBy([expenses.paidForPerson]);

    final results = await query.get();
    final debts = <String, double>{};

    for (final row in results) {
      final person = row.read(expenses.paidForPerson);
      final total = row.read(expenses.amount.sum()) ?? 0.0;
      if (person != null && person.isNotEmpty) {
        debts[person] = total;
      }
    }

    return debts;
  }
}
