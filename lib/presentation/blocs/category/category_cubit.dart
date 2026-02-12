import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/category_usecases.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final AddCategoryUseCase addCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;
  final SeedDefaultCategoriesUseCase seedDefaultCategoriesUseCase;

  CategoryCubit({
    required this.getAllCategoriesUseCase,
    required this.addCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
    required this.seedDefaultCategoriesUseCase,
  }) : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await getAllCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> seedCategories() async {
    try {
      await seedDefaultCategoriesUseCase();
      await loadCategories();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await addCategoryUseCase(category);
      await loadCategories();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await updateCategoryUseCase(category);
      await loadCategories();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await deleteCategoryUseCase(id);
      await loadCategories();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
