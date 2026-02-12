import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/usecases/expense_usecases.dart';
import 'package:expense_tracker/domain/usecases/category_usecases.dart';
import 'package:expense_tracker/presentation/blocs/expense/expense_bloc.dart';
import 'package:expense_tracker/presentation/blocs/expense/expense_event.dart';
import 'package:expense_tracker/presentation/blocs/expense/expense_state.dart';
import 'package:expense_tracker/presentation/blocs/category/category_cubit.dart';
import 'package:expense_tracker/presentation/blocs/category/category_state.dart';
import 'package:expense_tracker/presentation/blocs/settings/settings_cubit.dart';
import 'package:expense_tracker/presentation/blocs/settings/settings_state.dart';
import 'package:expense_tracker/presentation/widgets/expense_card.dart';
import 'package:expense_tracker/presentation/widgets/budget_progress_bar.dart';
import 'package:expense_tracker/presentation/pages/add_expense_page.dart';
import 'package:expense_tracker/core/utils/currency_formatter.dart';

// Mocks
class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

class MockGetAllExpensesUseCase extends Mock implements GetAllExpensesUseCase {}

class MockGetExpensesByDateRangeUseCase extends Mock
    implements GetExpensesByDateRangeUseCase {}

class MockGetExpensesByCategoryUseCase extends Mock
    implements GetExpensesByCategoryUseCase {}

class MockAddExpenseUseCase extends Mock implements AddExpenseUseCase {}

class MockUpdateExpenseUseCase extends Mock implements UpdateExpenseUseCase {}

class MockDeleteExpenseUseCase extends Mock implements DeleteExpenseUseCase {}

class MockGetAllCategoriesUseCase extends Mock
    implements GetAllCategoriesUseCase {}

class MockAddCategoryUseCase extends Mock implements AddCategoryUseCase {}

class MockUpdateCategoryUseCase extends Mock implements UpdateCategoryUseCase {}

class MockDeleteCategoryUseCase extends Mock implements DeleteCategoryUseCase {}

class MockSeedDefaultCategoriesUseCase extends Mock
    implements SeedDefaultCategoriesUseCase {}

void main() {
  final sl = GetIt.instance;

  final testExpense = Expense(
    id: 'exp1',
    amount: 42.50,
    categoryId: 'cat1',
    date: DateTime(2024, 6, 15),
    paymentMethod: 'Cash',
    isRecurring: false,
    createdAt: DateTime(2024, 6, 15),
    updatedAt: DateTime(2024, 6, 15),
    isSynced: false,
  );

  final testCategory = Category(
    id: 'cat1',
    name: 'Food',
    icon: 'restaurant',
    color: 0xFFFF5252,
    isCustom: false,
    createdAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(Expense(
      id: '',
      amount: 0,
      categoryId: '',
      date: DateTime(2000),
      paymentMethod: '',
      isRecurring: false,
      createdAt: DateTime(2000),
      updatedAt: DateTime(2000),
      isSynced: false,
    ));
    registerFallbackValue(Category(
      id: '',
      name: '',
      icon: '',
      color: 0,
      isCustom: false,
      createdAt: DateTime(2000),
    ));
  });

  tearDown(() async {
    await sl.reset();
  });

  group('CurrencyFormatter', () {
    test('formats with default dollar symbol', () {
      final result = CurrencyFormatter.format(42.50);
      expect(result, contains('\$'));
      expect(result, contains('42.50'));
    });

    test('formats with euro symbol', () {
      final result = CurrencyFormatter.format(42.50, symbol: '€');
      expect(result, contains('€'));
      expect(result, contains('42.50'));
    });

    test('formats with rupee symbol', () {
      final result = CurrencyFormatter.format(42.50, symbol: '₹');
      expect(result, contains('₹'));
      expect(result, contains('42.50'));
    });

    test('formatCompact uses provided symbol', () {
      final result = CurrencyFormatter.formatCompact(1500.0, symbol: '£');
      expect(result, contains('£'));
      expect(result, contains('1.5K'));
    });
  });

  group('BudgetProgressBar currency symbol', () {
    testWidgets('displays default dollar symbol', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BudgetProgressBar(
              spent: 70.0,
              budget: 100.0,
              categoryName: 'Food',
            ),
          ),
        ),
      );

      expect(find.text('\$70.00 / \$100.00'), findsOneWidget);
    });

    testWidgets('displays euro symbol when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BudgetProgressBar(
              spent: 70.0,
              budget: 100.0,
              categoryName: 'Food',
              currencySymbol: '€',
            ),
          ),
        ),
      );

      expect(find.text('€70.00 / €100.00'), findsOneWidget);
    });

    testWidgets('displays rupee symbol when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BudgetProgressBar(
              spent: 150.0,
              budget: 200.0,
              categoryName: 'Transport',
              currencySymbol: '₹',
            ),
          ),
        ),
      );

      expect(find.text('₹150.00 / ₹200.00'), findsOneWidget);
    });
  });

  group('ExpenseCard currency symbol propagation', () {
    late MockSettingsCubit settingsCubit;

    setUp(() {
      settingsCubit = MockSettingsCubit();
    });

    testWidgets('displays dollar symbol by default', (tester) async {
      when(() => settingsCubit.state).thenReturn(const SettingsState());

      await tester.pumpWidget(
        BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: MaterialApp(
            home: Scaffold(
              body: ExpenseCard(
                expense: testExpense,
                category: testCategory,
              ),
            ),
          ),
        ),
      );

      // Should display with $ symbol
      expect(find.textContaining('\$'), findsOneWidget);
      expect(find.textContaining('42.50'), findsOneWidget);
    });

    testWidgets('displays euro symbol when currency changed', (tester) async {
      when(() => settingsCubit.state).thenReturn(
        const SettingsState(currency: 'EUR', currencySymbol: '€'),
      );

      await tester.pumpWidget(
        BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: MaterialApp(
            home: Scaffold(
              body: ExpenseCard(
                expense: testExpense,
                category: testCategory,
              ),
            ),
          ),
        ),
      );

      // Should display with € symbol, not $
      expect(find.textContaining('€'), findsOneWidget);
      expect(find.textContaining('42.50'), findsOneWidget);
    });

    testWidgets('updates symbol reactively when settings change',
        (tester) async {
      final controller = StreamController<SettingsState>.broadcast();

      // Start with USD
      when(() => settingsCubit.state).thenReturn(const SettingsState());
      whenListen(
        settingsCubit,
        controller.stream,
        initialState: const SettingsState(),
      );

      await tester.pumpWidget(
        BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: MaterialApp(
            home: Scaffold(
              body: ExpenseCard(
                expense: testExpense,
                category: testCategory,
              ),
            ),
          ),
        ),
      );

      // Initially shows $
      expect(find.textContaining('\$'), findsOneWidget);

      // Emit new state with EUR
      controller.add(
        const SettingsState(currency: 'EUR', currencySymbol: '€'),
      );
      await tester.pumpAndSettle();

      // Now should show €
      expect(find.textContaining('€'), findsOneWidget);

      await controller.close();
    });
  });

  group('AddExpensePage currency symbol in amount field', () {
    late MockSettingsCubit settingsCubit;
    late ExpenseBloc expenseBloc;
    late CategoryCubit categoryCubit;

    setUp(() async {
      await sl.reset();

      settingsCubit = MockSettingsCubit();

      final mockGetAll = MockGetAllExpensesUseCase();
      final mockGetByDateRange = MockGetExpensesByDateRangeUseCase();
      final mockGetByCategory = MockGetExpensesByCategoryUseCase();
      final mockAdd = MockAddExpenseUseCase();
      final mockUpdate = MockUpdateExpenseUseCase();
      final mockDelete = MockDeleteExpenseUseCase();

      when(() => mockAdd(any())).thenAnswer((_) async {});
      when(() => mockGetAll()).thenAnswer((_) async => []);

      expenseBloc = ExpenseBloc(
        getAllExpensesUseCase: mockGetAll,
        getExpensesByDateRangeUseCase: mockGetByDateRange,
        getExpensesByCategoryUseCase: mockGetByCategory,
        addExpenseUseCase: mockAdd,
        updateExpenseUseCase: mockUpdate,
        deleteExpenseUseCase: mockDelete,
      );

      final mockGetAllCategories = MockGetAllCategoriesUseCase();
      final mockAddCategory = MockAddCategoryUseCase();
      final mockUpdateCategory = MockUpdateCategoryUseCase();
      final mockDeleteCategory = MockDeleteCategoryUseCase();
      final mockSeedCategories = MockSeedDefaultCategoriesUseCase();

      when(() => mockGetAllCategories())
          .thenAnswer((_) async => [testCategory]);

      categoryCubit = CategoryCubit(
        getAllCategoriesUseCase: mockGetAllCategories,
        addCategoryUseCase: mockAddCategory,
        updateCategoryUseCase: mockUpdateCategory,
        deleteCategoryUseCase: mockDeleteCategory,
        seedDefaultCategoriesUseCase: mockSeedCategories,
      );

      sl.registerLazySingleton<ExpenseBloc>(() => expenseBloc);
      sl.registerFactory<CategoryCubit>(() => categoryCubit);
      sl.registerLazySingleton<SettingsCubit>(() => settingsCubit);
    });

    testWidgets('shows dollar prefix by default', (tester) async {
      when(() => settingsCubit.state).thenReturn(const SettingsState());

      await tester.pumpWidget(
        BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: const MaterialApp(
            home: AddExpensePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The amount field should show the $ prefix text
      expect(find.text('\$ '), findsOneWidget);
    });

    testWidgets('shows euro prefix when currency is EUR', (tester) async {
      when(() => settingsCubit.state).thenReturn(
        const SettingsState(currency: 'EUR', currencySymbol: '€'),
      );

      await tester.pumpWidget(
        BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: const MaterialApp(
            home: AddExpensePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The amount field should show the € prefix text
      expect(find.text('€ '), findsOneWidget);
    });
  });
}
