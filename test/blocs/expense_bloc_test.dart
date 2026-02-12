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
  });
}
