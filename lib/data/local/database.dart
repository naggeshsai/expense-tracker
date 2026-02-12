import 'package:drift/drift.dart';
import 'tables/expense_table.dart';
import 'tables/category_table.dart';
import 'tables/budget_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Expenses, Categories, Budgets])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add isForOther and paidForPerson columns to expenses table
          await m.addColumn(expenses, expenses.isForOther);
          await m.addColumn(expenses, expenses.paidForPerson);
        }
      },
    );
  }
}
