import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:expense_tracker/domain/usecases/expense_usecases.dart';
import 'package:expense_tracker/presentation/blocs/expense/expense_bloc.dart';
import 'package:expense_tracker/presentation/blocs/expense/expense_event.dart';
import 'package:expense_tracker/presentation/blocs/expense/expense_state.dart';

class MockGetAllExpensesUseCase extends Mock implements GetAllExpensesUseCase {}
class MockGetExpensesByDateRangeUseCase extends Mock implements GetExpensesByDateRangeUseCase {}
class MockGetExpensesByCategoryUseCase extends Mock implements GetExpensesByCategoryUseCase {}
class MockAddExpenseUseCase extends Mock implements AddExpenseUseCase {}
class MockUpdateExpenseUseCase extends Mock implements UpdateExpenseUseCase {}
class MockDeleteExpenseUseCase extends Mock implements DeleteExpenseUseCase {}

void main() {
  late ExpenseBloc expenseBloc;
  late MockGetAllExpensesUseCase mockGetAllExpensesUseCase;
  late MockGetExpensesByDateRangeUseCase mockGetExpensesByDateRangeUseCase;
  late MockGetExpensesByCategoryUseCase mockGetExpensesByCategoryUseCase;
  late MockAddExpenseUseCase mockAddExpenseUseCase;
  late MockUpdateExpenseUseCase mockUpdateExpenseUseCase;
  late MockDeleteExpenseUseCase mockDeleteExpenseUseCase;

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
  });

  setUp(() {
    mockGetAllExpensesUseCase = MockGetAllExpensesUseCase();
    mockGetExpensesByDateRangeUseCase = MockGetExpensesByDateRangeUseCase();
    mockGetExpensesByCategoryUseCase = MockGetExpensesByCategoryUseCase();
    mockAddExpenseUseCase = MockAddExpenseUseCase();
    mockUpdateExpenseUseCase = MockUpdateExpenseUseCase();
    mockDeleteExpenseUseCase = MockDeleteExpenseUseCase();

    expenseBloc = ExpenseBloc(
      getAllExpensesUseCase: mockGetAllExpensesUseCase,
      getExpensesByDateRangeUseCase: mockGetExpensesByDateRangeUseCase,
      getExpensesByCategoryUseCase: mockGetExpensesByCategoryUseCase,
      addExpenseUseCase: mockAddExpenseUseCase,
      updateExpenseUseCase: mockUpdateExpenseUseCase,
      deleteExpenseUseCase: mockDeleteExpenseUseCase,
    );
  });

  tearDown(() {
    expenseBloc.close();
  });

  final testExpense = Expense(
    id: '1',
    amount: 100.0,
    categoryId: 'cat1',
    date: DateTime.now(),
    paymentMethod: 'Cash',
    isRecurring: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isSynced: false,
  );

  group('ExpenseBloc', () {
    test('initial state is ExpenseInitial', () {
      expect(expenseBloc.state, equals(ExpenseInitial()));
    });

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseLoaded] when LoadExpenses is successful',
      build: () {
        when(() => mockGetAllExpensesUseCase()).thenAnswer((_) async => [testExpense]);
        return expenseBloc;
      },
      act: (bloc) => bloc.add(LoadExpenses()),
      expect: () => [
        ExpenseLoading(),
        ExpenseLoaded([testExpense]),
      ],
      verify: (_) {
        verify(() => mockGetAllExpensesUseCase()).called(1);
      },
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseError] when LoadExpenses fails',
      build: () {
        when(() => mockGetAllExpensesUseCase()).thenThrow(Exception('Failed to load'));
        return expenseBloc;
      },
      act: (bloc) => bloc.add(LoadExpenses()),
      expect: () => [
        ExpenseLoading(),
        isA<ExpenseError>(),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseOperationSuccess, ExpenseLoading, ExpenseLoaded] when AddExpense is successful',
      build: () {
        when(() => mockAddExpenseUseCase(any())).thenAnswer((_) async {});
        when(() => mockGetAllExpensesUseCase()).thenAnswer((_) async => [testExpense]);
        return expenseBloc;
      },
      act: (bloc) => bloc.add(AddExpense(testExpense)),
      expect: () => [
        ExpenseOperationSuccess('Expense added successfully'),
        ExpenseLoading(),
        ExpenseLoaded([testExpense]),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseOperationSuccess, ExpenseLoading, ExpenseLoaded] when DeleteExpense is successful',
      build: () {
        when(() => mockDeleteExpenseUseCase(any())).thenAnswer((_) async {});
        when(() => mockGetAllExpensesUseCase()).thenAnswer((_) async => []);
        return expenseBloc;
      },
      act: (bloc) => bloc.add(DeleteExpense('1')),
      expect: () => [
        ExpenseOperationSuccess('Expense deleted successfully'),
        ExpenseLoading(),
        ExpenseLoaded([]),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseOperationSuccess, ExpenseLoading, ExpenseLoaded] when UpdateExpense is successful',
      build: () {
        final updatedExpense = Expense(
          id: '1',
          amount: 200.0,
          categoryId: 'cat1',
          date: DateTime(2024, 6, 15),
          paymentMethod: 'Card',
          isRecurring: false,
          createdAt: DateTime(2024, 6, 15),
          updatedAt: DateTime(2024, 6, 15),
          isSynced: false,
        );
        when(() => mockUpdateExpenseUseCase(any())).thenAnswer((_) async {});
        when(() => mockGetAllExpensesUseCase()).thenAnswer((_) async => [updatedExpense]);
        return expenseBloc;
      },
      act: (bloc) => bloc.add(UpdateExpense(testExpense)),
      expect: () => [
        ExpenseOperationSuccess('Expense updated successfully'),
        ExpenseLoading(),
        isA<ExpenseLoaded>(),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseLoaded] when LoadExpensesByDateRange is successful',
      build: () {
        when(() => mockGetExpensesByDateRangeUseCase(any(), any()))
            .thenAnswer((_) async => [testExpense]);
        return expenseBloc;
      },
      act: (bloc) => bloc.add(LoadExpensesByDateRange(
        DateTime(2024, 1, 1),
        DateTime(2024, 12, 31),
      )),
      expect: () => [
        ExpenseLoading(),
        ExpenseLoaded([testExpense]),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseError] when LoadExpensesByDateRange fails',
      build: () {
        when(() => mockGetExpensesByDateRangeUseCase(any(), any()))
            .thenThrow(Exception('Date range error'));
        return expenseBloc;
      },
      act: (bloc) => bloc.add(LoadExpensesByDateRange(
        DateTime(2024, 1, 1),
        DateTime(2024, 12, 31),
      )),
      expect: () => [
        ExpenseLoading(),
        isA<ExpenseError>(),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseLoaded] when LoadExpensesByCategory is successful',
      build: () {
        when(() => mockGetExpensesByCategoryUseCase(any()))
            .thenAnswer((_) async => [testExpense]);
        return expenseBloc;
      },
      act: (bloc) => bloc.add(LoadExpensesByCategory('cat1')),
      expect: () => [
        ExpenseLoading(),
        ExpenseLoaded([testExpense]),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseError] when LoadExpensesByCategory fails',
      build: () {
        when(() => mockGetExpensesByCategoryUseCase(any()))
            .thenThrow(Exception('Category error'));
        return expenseBloc;
      },
      act: (bloc) => bloc.add(LoadExpensesByCategory('cat1')),
      expect: () => [
        ExpenseLoading(),
        isA<ExpenseError>(),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseError] when AddExpense fails',
      build: () {
        when(() => mockAddExpenseUseCase(any()))
            .thenThrow(Exception('Add failed'));
        return expenseBloc;
      },
      act: (bloc) => bloc.add(AddExpense(testExpense)),
      expect: () => [
        isA<ExpenseError>(),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseError] when UpdateExpense fails',
      build: () {
        when(() => mockUpdateExpenseUseCase(any()))
            .thenThrow(Exception('Update failed'));
        return expenseBloc;
      },
      act: (bloc) => bloc.add(UpdateExpense(testExpense)),
      expect: () => [
        isA<ExpenseError>(),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseError] when DeleteExpense fails',
      build: () {
        when(() => mockDeleteExpenseUseCase(any()))
            .thenThrow(Exception('Delete failed'));
        return expenseBloc;
      },
      act: (bloc) => bloc.add(DeleteExpense('1')),
      expect: () => [
        isA<ExpenseError>(),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'can add expense with isForOther fields set',
      build: () {
        final debtExpense = Expense(
          id: '2',
          amount: 50.0,
          categoryId: 'cat1',
          date: DateTime(2024, 6, 15),
          paymentMethod: 'Cash',
          isRecurring: false,
          isForOther: true,
          paidForPerson: 'Alice',
          createdAt: DateTime(2024, 6, 15),
          updatedAt: DateTime(2024, 6, 15),
          isSynced: false,
        );
        when(() => mockAddExpenseUseCase(any())).thenAnswer((_) async {});
        when(() => mockGetAllExpensesUseCase()).thenAnswer((_) async => [debtExpense]);
        return expenseBloc;
      },
      act: (bloc) => bloc.add(AddExpense(Expense(
        id: '2',
        amount: 50.0,
        categoryId: 'cat1',
        date: DateTime(2024, 6, 15),
        paymentMethod: 'Cash',
        isRecurring: false,
        isForOther: true,
        paidForPerson: 'Alice',
        createdAt: DateTime(2024, 6, 15),
        updatedAt: DateTime(2024, 6, 15),
        isSynced: false,
      ))),
      expect: () => [
        ExpenseOperationSuccess('Expense added successfully'),
        ExpenseLoading(),
        isA<ExpenseLoaded>().having(
          (s) => s.expenses.first.isForOther,
          'isForOther',
          true,
        ),
      ],
    );
  });
}
