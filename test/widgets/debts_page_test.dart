import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:expense_tracker/domain/entities/person_debt.dart';
import 'package:expense_tracker/domain/usecases/expense_usecases.dart';
import 'package:expense_tracker/presentation/blocs/debt/debt_cubit.dart';
import 'package:expense_tracker/presentation/blocs/debt/debt_state.dart';
import 'package:expense_tracker/presentation/blocs/settings/settings_cubit.dart';
import 'package:expense_tracker/presentation/blocs/settings/settings_state.dart';
import 'package:expense_tracker/presentation/blocs/category/category_cubit.dart';
import 'package:expense_tracker/presentation/blocs/category/category_state.dart';
import 'package:expense_tracker/domain/usecases/category_usecases.dart';
import 'package:expense_tracker/presentation/pages/debts_page.dart';

class MockDebtCubit extends MockCubit<DebtState> implements DebtCubit {}

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

class MockGetDebtsByPersonUseCase extends Mock
    implements GetDebtsByPersonUseCase {}

class MockGetExpensesByPersonUseCase extends Mock
    implements GetExpensesByPersonUseCase {}

class MockGetAllCategoriesUseCase extends Mock
    implements GetAllCategoriesUseCase {}

class MockAddCategoryUseCase extends Mock implements AddCategoryUseCase {}

class MockUpdateCategoryUseCase extends Mock implements UpdateCategoryUseCase {}

class MockDeleteCategoryUseCase extends Mock implements DeleteCategoryUseCase {}

class MockSeedDefaultCategoriesUseCase extends Mock
    implements SeedDefaultCategoriesUseCase {}

void main() {
  late MockSettingsCubit settingsCubit;
  late MockGetDebtsByPersonUseCase mockGetDebts;
  late MockGetExpensesByPersonUseCase mockGetExpensesByPerson;

  final sl = GetIt.instance;

  setUp(() async {
    await sl.reset();

    settingsCubit = MockSettingsCubit();
    when(() => settingsCubit.state).thenReturn(const SettingsState());
    sl.registerLazySingleton<SettingsCubit>(() => settingsCubit);

    mockGetDebts = MockGetDebtsByPersonUseCase();
    mockGetExpensesByPerson = MockGetExpensesByPersonUseCase();

    // Register CategoryCubit factory (needed for PersonDebtDetailPage navigation)
    final mockGetAllCategories = MockGetAllCategoriesUseCase();
    when(() => mockGetAllCategories()).thenAnswer((_) async => []);
    sl.registerFactory<CategoryCubit>(() => CategoryCubit(
          getAllCategoriesUseCase: mockGetAllCategories,
          addCategoryUseCase: MockAddCategoryUseCase(),
          updateCategoryUseCase: MockUpdateCategoryUseCase(),
          deleteCategoryUseCase: MockDeleteCategoryUseCase(),
          seedDefaultCategoriesUseCase: MockSeedDefaultCategoriesUseCase(),
        ));
  });

  tearDown(() async {
    await sl.reset();
  });

  Widget createTestWidget({required DebtState initialState}) {
    final debtCubit = DebtCubit(
      getDebtsByPersonUseCase: mockGetDebts,
      getExpensesByPersonUseCase: mockGetExpensesByPerson,
    );

    // We need to provide the debts page inside proper providers
    return BlocProvider<SettingsCubit>.value(
      value: settingsCubit,
      child: MaterialApp(
        home: BlocProvider<DebtCubit>.value(
          value: debtCubit,
          child: Scaffold(
            body: BlocBuilder<DebtCubit, DebtState>(
              builder: (context, state) {
                // We need to manually test the DebtsPage
                // since it creates its own DebtCubit via sl
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget createDebtsPage() {
    sl.registerFactory<DebtCubit>(() => DebtCubit(
          getDebtsByPersonUseCase: mockGetDebts,
          getExpensesByPersonUseCase: mockGetExpensesByPerson,
        ));

    return BlocProvider<SettingsCubit>.value(
      value: settingsCubit,
      child: const MaterialApp(
        home: DebtsPage(),
      ),
    );
  }

  group('DebtsPage', () {
    testWidgets('shows empty state when no debts', (tester) async {
      when(() => mockGetDebts()).thenAnswer((_) async => <String, double>{});

      await tester.pumpWidget(createDebtsPage());
      await tester.pumpAndSettle();

      expect(find.text('No debts tracked'), findsOneWidget);
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
      expect(
        find.text(
            'When adding an expense, toggle\n"Paid for someone else" to track debts'),
        findsOneWidget,
      );
    });

    testWidgets('shows loading state', (tester) async {
      // Use a completer to keep the future pending without a timer
      final completer = Completer<Map<String, double>>();
      when(() => mockGetDebts()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createDebtsPage());
      await tester.pump(); // Only pump once — don't settle

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future to avoid pending timer issues
      completer.complete(<String, double>{});
      await tester.pumpAndSettle();
    });

    testWidgets('shows person list when debts loaded', (tester) async {
      when(() => mockGetDebts()).thenAnswer(
        (_) async => {'Alice': 80.0, 'Bob': 100.0},
      );

      await tester.pumpWidget(createDebtsPage());
      await tester.pumpAndSettle();

      // Bob should be first (sorted by totalOwed desc)
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Who Owes You'), findsOneWidget);
    });

    testWidgets('shows total owed summary card', (tester) async {
      when(() => mockGetDebts()).thenAnswer(
        (_) async => {'Alice': 80.0, 'Bob': 100.0},
      );

      await tester.pumpWidget(createDebtsPage());
      await tester.pumpAndSettle();

      expect(find.text('Total Owed to You'), findsOneWidget);
      // Total = 80 + 100 = 180
      expect(find.textContaining('180.00'), findsOneWidget);
      expect(find.text('2 people'), findsOneWidget);
    });

    testWidgets('shows "1 person" for single debt', (tester) async {
      when(() => mockGetDebts()).thenAnswer(
        (_) async => {'Alice': 50.0},
      );

      await tester.pumpWidget(createDebtsPage());
      await tester.pumpAndSettle();

      expect(find.text('1 person'), findsOneWidget);
    });

    testWidgets('uses currency symbol from SettingsCubit', (tester) async {
      when(() => settingsCubit.state).thenReturn(
        const SettingsState(currencySymbol: '€', currency: 'EUR'),
      );
      when(() => mockGetDebts()).thenAnswer(
        (_) async => {'Alice': 42.50},
      );

      await tester.pumpWidget(createDebtsPage());
      await tester.pumpAndSettle();

      expect(find.textContaining('€'), findsWidgets);
    });

    testWidgets('shows avatar with first letter of person name',
        (tester) async {
      when(() => mockGetDebts()).thenAnswer(
        (_) async => {'Alice': 80.0},
      );

      await tester.pumpWidget(createDebtsPage());
      await tester.pumpAndSettle();

      // The CircleAvatar should contain "A"
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('"Tap to see details" subtitle is shown', (tester) async {
      when(() => mockGetDebts()).thenAnswer(
        (_) async => {'Alice': 80.0},
      );

      await tester.pumpWidget(createDebtsPage());
      await tester.pumpAndSettle();

      expect(find.text('Tap to see details'), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      when(() => mockGetDebts()).thenThrow(Exception('Database error'));

      await tester.pumpWidget(createDebtsPage());
      await tester.pumpAndSettle();

      expect(find.textContaining('Error'), findsOneWidget);
    });
  });
}
