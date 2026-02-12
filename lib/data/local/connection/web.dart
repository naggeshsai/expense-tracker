import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import '../database.dart';

AppDatabase constructDb() {
  return AppDatabase(_connectOnWeb());
}

DatabaseConnection _connectOnWeb() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'expense_tracker_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      // ignore: avoid_print
      print('Using ${result.chosenImplementation} due to missing browser '
          'features: ${result.missingFeatures}');
    }

    return result.resolvedExecutor;
  }));
}
