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
import 'package:expense_tracker/presentation/pages/add_expense_page.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

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
  late MockSettingsCubit settingsCubit;

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

    // Setup SettingsCubit mock with default USD state
    settingsCubit = MockSettingsCubit();
    when(() => settingsCubit.state).thenReturn(const SettingsState());
    sl.registerLazySingleton<SettingsCubit>(() => settingsCubit);
  });

  tearDown(() async {
    await sl.reset();
  });

  Widget createTestWidget({Expense? expense}) {
    return BlocProvider<SettingsCubit>.value(
      value: settingsCubit,
      child: MaterialApp(
        home: AddExpensePage(expense: expense),
      ),
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

    testWidgets(
      'shows "Paid for someone else" switch toggle',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify the switch is present
        expect(find.text('Paid for someone else'), findsOneWidget);
        expect(find.text('Track who owes you'), findsOneWidget);
        expect(find.byType(SwitchListTile), findsOneWidget);
      },
    );

    testWidgets(
      'person name field is hidden by default',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Person name field should NOT be visible
        expect(find.text('Person Name'), findsNothing);
        expect(find.text('Who is this expense for?'), findsNothing);
      },
    );

    testWidgets(
      'toggling switch shows person name field',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Scroll to make the switch visible then tap it
        final switchTile = find.byType(SwitchListTile);
        await tester.ensureVisible(switchTile);
        await tester.pumpAndSettle();
        await tester.tap(switchTile);
        await tester.pumpAndSettle();

        // Now the person name field should appear
        expect(find.text('Person Name'), findsOneWidget);
      },
    );

    testWidgets(
      'person name is required when switch is on',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter amount
        final amountField = find.byType(TextFormField).first;
        await tester.enterText(amountField, '42.50');
        await tester.pumpAndSettle();

        // Enable "Paid for someone else"
        final switchTile = find.byType(SwitchListTile);
        await tester.ensureVisible(switchTile);
        await tester.pumpAndSettle();
        await tester.tap(switchTile);
        await tester.pumpAndSettle();

        // Try to save without entering person name
        final saveButton =
            find.widgetWithText(ElevatedButton, 'Add Expense');
        await tester.ensureVisible(saveButton);
        await tester.pumpAndSettle();
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Validation error should appear
        expect(find.text('Please enter the person\'s name'), findsOneWidget);
      },
    );

    testWidgets(
      'saves expense with debt fields when filled',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter amount
        final amountField = find.byType(TextFormField).first;
        await tester.enterText(amountField, '100.00');
        await tester.pumpAndSettle();

        // Enable "Paid for someone else"
        final switchTile = find.byType(SwitchListTile);
        await tester.ensureVisible(switchTile);
        await tester.pumpAndSettle();
        await tester.tap(switchTile);
        await tester.pumpAndSettle();

        // Enter person name
        final personNameField = find.widgetWithText(TextFormField, 'Person Name');
        await tester.enterText(personNameField, 'Alice');
        await tester.pumpAndSettle();

        // Scroll to save button and tap
        final saveButton =
            find.widgetWithText(ElevatedButton, 'Add Expense');
        await tester.ensureVisible(saveButton);
        await tester.pumpAndSettle();
        await tester.tap(saveButton);
        await tester.pump();

        // Should save successfully (SnackBar appears)
        expect(find.text('Expense added successfully'), findsOneWidget);
      },
    );

    testWidgets(
      'edit expense with debt fields pre-fills the form',
      (WidgetTester tester) async {
        final existingDebtExpense = Expense(
          id: 'exp-debt1',
          amount: 75.0,
          categoryId: 'cat1',
          date: DateTime(2024, 6, 15),
          paymentMethod: 'Cash',
          isRecurring: false,
          isForOther: true,
          paidForPerson: 'Bob',
          createdAt: DateTime(2024, 6, 15),
          updatedAt: DateTime(2024, 6, 15),
          isSynced: false,
        );

        await tester
            .pumpWidget(createTestWidget(expense: existingDebtExpense));
        await tester.pumpAndSettle();

        // The switch should be ON
        final switchTile =
            tester.widget<SwitchListTile>(find.byType(SwitchListTile));
        expect(switchTile.value, true);

        // Person name field should show "Bob"
        expect(find.text('Bob'), findsOneWidget);
      },
    );

    testWidgets(
      'toggling switch off clears person name',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enable "Paid for someone else"
        final switchTileFinder = find.byType(SwitchListTile);
        await tester.ensureVisible(switchTileFinder);
        await tester.pumpAndSettle();
        await tester.tap(switchTileFinder);
        await tester.pumpAndSettle();

        // Enter person name
        final personNameField = find.widgetWithText(TextFormField, 'Person Name');
        await tester.enterText(personNameField, 'Charlie');
        await tester.pumpAndSettle();

        // Toggle switch off
        await tester.tap(switchTileFinder);
        await tester.pumpAndSettle();

        // Person name field should be hidden
        expect(find.text('Person Name'), findsNothing);

        // Toggle switch on again — the field should be empty
        await tester.tap(switchTileFinder);
        await tester.pumpAndSettle();

        // The text should be cleared
        final personField = tester.widget<TextFormField>(
            find.widgetWithText(TextFormField, 'Person Name'));
        expect(personField.controller!.text, isEmpty);
      },
    );
  });
}
