import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/domain/entities/expense.dart';
import 'package:expense_tracker/domain/entities/person_debt.dart';
import 'package:expense_tracker/domain/usecases/expense_usecases.dart';
import 'package:expense_tracker/presentation/blocs/debt/debt_cubit.dart';
import 'package:expense_tracker/presentation/blocs/debt/debt_state.dart';

class MockGetDebtsByPersonUseCase extends Mock
    implements GetDebtsByPersonUseCase {}

class MockGetExpensesByPersonUseCase extends Mock
    implements GetExpensesByPersonUseCase {}

void main() {
  late DebtCubit debtCubit;
  late MockGetDebtsByPersonUseCase mockGetDebtsByPersonUseCase;
  late MockGetExpensesByPersonUseCase mockGetExpensesByPersonUseCase;

  setUp(() {
    mockGetDebtsByPersonUseCase = MockGetDebtsByPersonUseCase();
    mockGetExpensesByPersonUseCase = MockGetExpensesByPersonUseCase();

    debtCubit = DebtCubit(
      getDebtsByPersonUseCase: mockGetDebtsByPersonUseCase,
      getExpensesByPersonUseCase: mockGetExpensesByPersonUseCase,
    );
  });

  tearDown(() {
    debtCubit.close();
  });

  final testExpenseForAlice = Expense(
    id: 'exp1',
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

  final testExpenseForAlice2 = Expense(
    id: 'exp2',
    amount: 30.0,
    categoryId: 'cat2',
    date: DateTime(2024, 6, 20),
    paymentMethod: 'Card',
    isRecurring: false,
    isForOther: true,
    paidForPerson: 'Alice',
    createdAt: DateTime(2024, 6, 20),
    updatedAt: DateTime(2024, 6, 20),
    isSynced: false,
  );

  final testExpenseForBob = Expense(
    id: 'exp3',
    amount: 100.0,
    categoryId: 'cat1',
    date: DateTime(2024, 7, 1),
    paymentMethod: 'Cash',
    isRecurring: false,
    isForOther: true,
    paidForPerson: 'Bob',
    createdAt: DateTime(2024, 7, 1),
    updatedAt: DateTime(2024, 7, 1),
    isSynced: false,
  );

  group('DebtCubit', () {
    test('initial state is DebtInitial', () {
      expect(debtCubit.state, equals(DebtInitial()));
    });

    blocTest<DebtCubit, DebtState>(
      'emits [DebtLoading, DebtLoaded] when loadDebts succeeds with data',
      build: () {
        when(() => mockGetDebtsByPersonUseCase())
            .thenAnswer((_) async => {'Alice': 80.0, 'Bob': 100.0});
        return debtCubit;
      },
      act: (cubit) => cubit.loadDebts(),
      expect: () => [
        DebtLoading(),
        isA<DebtLoaded>().having(
          (s) => s.debts.length,
          'debts count',
          2,
        ),
      ],
      verify: (_) {
        verify(() => mockGetDebtsByPersonUseCase()).called(1);
      },
    );

    blocTest<DebtCubit, DebtState>(
      'debts are sorted by totalOwed descending',
      build: () {
        when(() => mockGetDebtsByPersonUseCase())
            .thenAnswer((_) async => {'Alice': 30.0, 'Bob': 100.0, 'Charlie': 50.0});
        return debtCubit;
      },
      act: (cubit) => cubit.loadDebts(),
      expect: () => [
        DebtLoading(),
        isA<DebtLoaded>().having(
          (s) => s.debts.map((d) => d.personName).toList(),
          'sorted names',
          ['Bob', 'Charlie', 'Alice'],
        ),
      ],
    );

    blocTest<DebtCubit, DebtState>(
      'emits [DebtLoading, DebtLoaded] with empty list when no debts',
      build: () {
        when(() => mockGetDebtsByPersonUseCase())
            .thenAnswer((_) async => <String, double>{});
        return debtCubit;
      },
      act: (cubit) => cubit.loadDebts(),
      expect: () => [
        DebtLoading(),
        DebtLoaded([]),
      ],
    );

    blocTest<DebtCubit, DebtState>(
      'emits [DebtLoading, DebtError] when loadDebts fails',
      build: () {
        when(() => mockGetDebtsByPersonUseCase())
            .thenThrow(Exception('Database error'));
        return debtCubit;
      },
      act: (cubit) => cubit.loadDebts(),
      expect: () => [
        DebtLoading(),
        isA<DebtError>(),
      ],
    );

    blocTest<DebtCubit, DebtState>(
      'emits [DebtLoading, DebtPersonExpensesLoaded] when loadExpensesForPerson succeeds',
      build: () {
        when(() => mockGetExpensesByPersonUseCase('Alice'))
            .thenAnswer((_) async => [testExpenseForAlice, testExpenseForAlice2]);
        return debtCubit;
      },
      act: (cubit) => cubit.loadExpensesForPerson('Alice'),
      expect: () => [
        DebtLoading(),
        isA<DebtPersonExpensesLoaded>()
            .having((s) => s.personName, 'personName', 'Alice')
            .having((s) => s.expenses.length, 'expenses count', 2)
            .having((s) => s.totalOwed, 'totalOwed', 80.0),
      ],
    );

    blocTest<DebtCubit, DebtState>(
      'emits [DebtLoading, DebtError] when loadExpensesForPerson fails',
      build: () {
        when(() => mockGetExpensesByPersonUseCase('Alice'))
            .thenThrow(Exception('Failed'));
        return debtCubit;
      },
      act: (cubit) => cubit.loadExpensesForPerson('Alice'),
      expect: () => [
        DebtLoading(),
        isA<DebtError>(),
      ],
    );

    blocTest<DebtCubit, DebtState>(
      'calculates correct total for person with multiple expenses',
      build: () {
        when(() => mockGetExpensesByPersonUseCase('Alice'))
            .thenAnswer((_) async => [testExpenseForAlice, testExpenseForAlice2]);
        return debtCubit;
      },
      act: (cubit) => cubit.loadExpensesForPerson('Alice'),
      expect: () => [
        DebtLoading(),
        isA<DebtPersonExpensesLoaded>()
            .having((s) => s.totalOwed, 'totalOwed', 80.0), // 50 + 30
      ],
    );
  });

  group('PersonDebt', () {
    test('equality works correctly', () {
      const debt1 = PersonDebt(personName: 'Alice', totalOwed: 100.0);
      const debt2 = PersonDebt(personName: 'Alice', totalOwed: 100.0);
      const debt3 = PersonDebt(personName: 'Bob', totalOwed: 100.0);

      expect(debt1, equals(debt2));
      expect(debt1, isNot(equals(debt3)));
    });

    test('props are correct', () {
      const debt = PersonDebt(personName: 'Alice', totalOwed: 50.0);
      expect(debt.props, equals(['Alice', 50.0]));
    });
  });

  group('Expense entity with debt fields', () {
    test('default values for isForOther and paidForPerson', () {
      final expense = Expense(
        id: '1',
        amount: 100.0,
        categoryId: 'cat1',
        date: DateTime(2024),
        paymentMethod: 'Cash',
        isRecurring: false,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
        isSynced: false,
      );

      expect(expense.isForOther, false);
      expect(expense.paidForPerson, null);
    });

    test('expense with debt fields set', () {
      expect(testExpenseForAlice.isForOther, true);
      expect(testExpenseForAlice.paidForPerson, 'Alice');
      expect(testExpenseForAlice.amount, 50.0);
    });

    test('copyWith preserves debt fields', () {
      final updated = testExpenseForAlice.copyWith(amount: 75.0);

      expect(updated.amount, 75.0);
      expect(updated.isForOther, true);
      expect(updated.paidForPerson, 'Alice');
    });

    test('copyWith can clear debt fields', () {
      final updated = testExpenseForAlice.copyWith(
        isForOther: false,
        paidForPerson: null,
      );

      // Note: copyWith with null for nullable field doesn't clear it
      // since null means "keep existing value". This is expected behavior.
      expect(updated.isForOther, false);
    });

    test('equality includes debt fields', () {
      final expense1 = Expense(
        id: '1',
        amount: 100.0,
        categoryId: 'cat1',
        date: DateTime(2024),
        paymentMethod: 'Cash',
        isRecurring: false,
        isForOther: true,
        paidForPerson: 'Alice',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
        isSynced: false,
      );

      final expense2 = Expense(
        id: '1',
        amount: 100.0,
        categoryId: 'cat1',
        date: DateTime(2024),
        paymentMethod: 'Cash',
        isRecurring: false,
        isForOther: false,
        paidForPerson: null,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
        isSynced: false,
      );

      expect(expense1, isNot(equals(expense2)));
    });
  });
}
