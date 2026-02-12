import 'package:get_it/get_it.dart';
import 'data/local/database.dart';
import 'data/local/connection/connection.dart';
import 'data/local/daos/expense_dao.dart';
import 'data/local/daos/category_dao.dart';
import 'data/local/daos/budget_dao.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/budget_repository_impl.dart';
import 'domain/repositories/expense_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/budget_repository.dart';
import 'domain/usecases/expense_usecases.dart';
import 'domain/usecases/category_usecases.dart';
import 'domain/usecases/budget_usecases.dart';
import 'presentation/blocs/expense/expense_bloc.dart';
import 'presentation/blocs/category/category_cubit.dart';
import 'presentation/blocs/budget/budget_cubit.dart';
import 'presentation/blocs/dashboard/dashboard_cubit.dart';
import 'presentation/blocs/settings/settings_cubit.dart';
import 'presentation/blocs/debt/debt_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Database
  sl.registerLazySingleton<AppDatabase>(() => constructDb());

  // DAOs
  sl.registerLazySingleton<ExpenseDao>(() => ExpenseDao(sl()));
  sl.registerLazySingleton<CategoryDao>(() => CategoryDao(sl()));
  sl.registerLazySingleton<BudgetDao>(() => BudgetDao(sl()));

  // Repositories
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(sl()),
  );

  // Use Cases - Expense
  sl.registerLazySingleton(() => GetAllExpensesUseCase(sl()));
  sl.registerLazySingleton(() => GetExpensesByDateRangeUseCase(sl()));
  sl.registerLazySingleton(() => GetExpensesByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => AddExpenseUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExpenseUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetTotalSpendingUseCase(sl()));
  sl.registerLazySingleton(() => GetCategorySpendingUseCase(sl()));
  sl.registerLazySingleton(() => GetExpensesForOthersUseCase(sl()));
  sl.registerLazySingleton(() => GetExpensesByPersonUseCase(sl()));
  sl.registerLazySingleton(() => GetDebtsByPersonUseCase(sl()));

  // Use Cases - Category
  sl.registerLazySingleton(() => GetAllCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoryByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddCategoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));
  sl.registerLazySingleton(() => SeedDefaultCategoriesUseCase(sl()));

  // Use Cases - Budget
  sl.registerLazySingleton(() => GetAllBudgetsUseCase(sl()));
  sl.registerLazySingleton(() => GetBudgetByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetBudgetByMonthYearUseCase(sl()));
  sl.registerLazySingleton(() => AddBudgetUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBudgetUseCase(sl()));
  sl.registerLazySingleton(() => DeleteBudgetUseCase(sl()));

  // BLoCs/Cubits
  sl.registerLazySingleton(
    () => ExpenseBloc(
      getAllExpensesUseCase: sl(),
      getExpensesByDateRangeUseCase: sl(),
      getExpensesByCategoryUseCase: sl(),
      addExpenseUseCase: sl(),
      updateExpenseUseCase: sl(),
      deleteExpenseUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => CategoryCubit(
      getAllCategoriesUseCase: sl(),
      addCategoryUseCase: sl(),
      updateCategoryUseCase: sl(),
      deleteCategoryUseCase: sl(),
      seedDefaultCategoriesUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => BudgetCubit(
      getAllBudgetsUseCase: sl(),
      getBudgetByMonthYearUseCase: sl(),
      addBudgetUseCase: sl(),
      updateBudgetUseCase: sl(),
      deleteBudgetUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => DashboardCubit(
      getTotalSpendingUseCase: sl(),
      getCategorySpendingUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => SettingsCubit());

  sl.registerFactory(
    () => DebtCubit(
      getDebtsByPersonUseCase: sl(),
      getExpensesByPersonUseCase: sl(),
    ),
  );
}
