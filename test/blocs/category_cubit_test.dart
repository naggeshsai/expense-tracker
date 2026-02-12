import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/domain/usecases/category_usecases.dart';
import 'package:expense_tracker/presentation/blocs/category/category_cubit.dart';
import 'package:expense_tracker/presentation/blocs/category/category_state.dart';

class MockGetAllCategoriesUseCase extends Mock implements GetAllCategoriesUseCase {}
class MockAddCategoryUseCase extends Mock implements AddCategoryUseCase {}
class MockUpdateCategoryUseCase extends Mock implements UpdateCategoryUseCase {}
class MockDeleteCategoryUseCase extends Mock implements DeleteCategoryUseCase {}
class MockSeedDefaultCategoriesUseCase extends Mock implements SeedDefaultCategoriesUseCase {}

void main() {
  late CategoryCubit categoryCubit;
  late MockGetAllCategoriesUseCase mockGetAllCategoriesUseCase;
  late MockAddCategoryUseCase mockAddCategoryUseCase;
  late MockUpdateCategoryUseCase mockUpdateCategoryUseCase;
  late MockDeleteCategoryUseCase mockDeleteCategoryUseCase;
  late MockSeedDefaultCategoriesUseCase mockSeedDefaultCategoriesUseCase;

  setUpAll(() {
    registerFallbackValue(Category(
      id: '',
      name: '',
      icon: '',
      color: 0,
      isCustom: false,
      createdAt: DateTime(2000),
    ));
  });

  setUp(() {
    mockGetAllCategoriesUseCase = MockGetAllCategoriesUseCase();
    mockAddCategoryUseCase = MockAddCategoryUseCase();
    mockUpdateCategoryUseCase = MockUpdateCategoryUseCase();
    mockDeleteCategoryUseCase = MockDeleteCategoryUseCase();
    mockSeedDefaultCategoriesUseCase = MockSeedDefaultCategoriesUseCase();

    categoryCubit = CategoryCubit(
      getAllCategoriesUseCase: mockGetAllCategoriesUseCase,
      addCategoryUseCase: mockAddCategoryUseCase,
      updateCategoryUseCase: mockUpdateCategoryUseCase,
      deleteCategoryUseCase: mockDeleteCategoryUseCase,
      seedDefaultCategoriesUseCase: mockSeedDefaultCategoriesUseCase,
    );
  });

  tearDown(() {
    categoryCubit.close();
  });

  final testCategory = Category(
    id: '1',
    name: 'Food',
    icon: 'restaurant',
    color: 0xFFFF6B6B,
    isCustom: false,
    createdAt: DateTime.now(),
  );

  group('CategoryCubit', () {
    test('initial state is CategoryInitial', () {
      expect(categoryCubit.state, equals(CategoryInitial()));
    });

    blocTest<CategoryCubit, CategoryState>(
      'emits [CategoryLoading, CategoryLoaded] when loadCategories is successful',
      build: () {
        when(() => mockGetAllCategoriesUseCase()).thenAnswer((_) async => [testCategory]);
        return categoryCubit;
      },
      act: (cubit) => cubit.loadCategories(),
      expect: () => [
        CategoryLoading(),
        CategoryLoaded([testCategory]),
      ],
    );

    blocTest<CategoryCubit, CategoryState>(
      'emits [CategoryLoading, CategoryError] when loadCategories fails',
      build: () {
        when(() => mockGetAllCategoriesUseCase()).thenThrow(Exception('Failed to load'));
        return categoryCubit;
      },
      act: (cubit) => cubit.loadCategories(),
      expect: () => [
        CategoryLoading(),
        isA<CategoryError>(),
      ],
    );

    blocTest<CategoryCubit, CategoryState>(
      'emits [CategoryLoading, CategoryLoaded] when addCategory is successful',
      build: () {
        when(() => mockAddCategoryUseCase(any())).thenAnswer((_) async {});
        when(() => mockGetAllCategoriesUseCase()).thenAnswer((_) async => [testCategory]);
        return categoryCubit;
      },
      act: (cubit) => cubit.addCategory(testCategory),
      expect: () => [
        CategoryLoading(),
        CategoryLoaded([testCategory]),
      ],
    );
  });
}
