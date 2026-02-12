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
import 'package:expense_tracker/presentation/pages/add_expense_page.dart';

// Mock use cases
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
  late ExpenseBloc expenseBloc;
  late CategoryCubit categoryCubit;

  final sl = GetIt.instance;

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

  setUp(() async {
    // Reset GetIt before each test
    await sl.reset();

    final mockGetAll = MockGetAllExpensesUseCase();
    final mockGetByDateRange = MockGetExpensesByDateRangeUseCase();
    final mockGetByCategory = MockGetExpensesByCategoryUseCase();
    final mockAdd = MockAddExpenseUseCase();
    final mockUpdate = MockUpdateExpenseUseCase();
    final mockDelete = MockDeleteExpenseUseCase();

    when(() => mockAdd(any())).thenAnswer((_) async {});
    when(() => mockUpdate(any())).thenAnswer((_) async {});
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

    // Register ExpenseBloc as singleton in GetIt (mirrors production setup)
    sl.registerLazySingleton<ExpenseBloc>(() => expenseBloc);
    sl.registerFactory<CategoryCubit>(() => categoryCubit);
  });

  tearDown(() async {
    await sl.reset();
  });

  Widget createTestWidget({Expense? expense}) {
    return MaterialApp(
      home: AddExpensePage(expense: expense),
    );
  }

  group('AddExpensePage', () {
    testWidgets(
      'saves expense using service locator instead of BuildContext provider',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        // Wait for CategoryCubit to load categories
        await tester.pumpAndSettle();

        // Enter amount
        final amountField = find.byType(TextFormField).first;
        await tester.enterText(amountField, '42.50');
        await tester.pumpAndSettle();

        // Scroll to make the save button visible, then tap it
        final elevatedButton =
            find.widgetWithText(ElevatedButton, 'Add Expense');
        await tester.ensureVisible(elevatedButton);
        await tester.pumpAndSettle();
        await tester.tap(elevatedButton);
        await tester.pumpAndSettle();

        // Verify: no ProviderNotFoundException thrown — page pops after save
        // The AddExpensePage should be gone (Navigator.pop was called)
        expect(find.byType(AddExpensePage), findsNothing);
      },
    );

    testWidgets(
      'shows success SnackBar when expense is added',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter amount
        final amountField = find.byType(TextFormField).first;
        await tester.enterText(amountField, '25.00');
        await tester.pumpAndSettle();

        // Scroll to button and tap
        final elevatedButton =
            find.widgetWithText(ElevatedButton, 'Add Expense');
        await tester.ensureVisible(elevatedButton);
        await tester.pumpAndSettle();
        await tester.tap(elevatedButton);
        await tester.pump(); // pump once to show SnackBar before Navigator.pop

        // Verify SnackBar appears
        expect(find.text('Expense added successfully'), findsOneWidget);
      },
    );

    testWidgets(
      'shows update SnackBar when editing existing expense',
      (WidgetTester tester) async {
        final existingExpense = Expense(
          id: 'exp1',
          amount: 50.0,
          categoryId: 'cat1',
          date: DateTime(2024, 6, 15),
          paymentMethod: 'Cash',
          isRecurring: false,
          createdAt: DateTime(2024, 6, 15),
          updatedAt: DateTime(2024, 6, 15),
          isSynced: false,
        );

        await tester.pumpWidget(createTestWidget(expense: existingExpense));
        await tester.pumpAndSettle();

        // Scroll to button and tap
        final elevatedButton =
            find.widgetWithText(ElevatedButton, 'Update Expense');
        await tester.ensureVisible(elevatedButton);
        await tester.pumpAndSettle();
        await tester.tap(elevatedButton);
        await tester.pump();

        // Verify update SnackBar
        expect(find.text('Expense updated successfully'), findsOneWidget);
      },
    );
  });
}
