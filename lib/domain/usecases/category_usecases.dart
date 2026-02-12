import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetAllCategoriesUseCase {
  final CategoryRepository repository;
  GetAllCategoriesUseCase(this.repository);
  Future<List<Category>> call() => repository.getAllCategories();
}

class GetCategoryByIdUseCase {
  final CategoryRepository repository;
  GetCategoryByIdUseCase(this.repository);
  Future<Category?> call(String id) => repository.getCategoryById(id);
}

class AddCategoryUseCase {
  final CategoryRepository repository;
  AddCategoryUseCase(this.repository);
  Future<void> call(Category category) => repository.addCategory(category);
}

class UpdateCategoryUseCase {
  final CategoryRepository repository;
  UpdateCategoryUseCase(this.repository);
  Future<void> call(Category category) => repository.updateCategory(category);
}

class DeleteCategoryUseCase {
  final CategoryRepository repository;
  DeleteCategoryUseCase(this.repository);
  Future<void> call(String id) => repository.deleteCategory(id);
}

class SeedDefaultCategoriesUseCase {
  final CategoryRepository repository;
  SeedDefaultCategoriesUseCase(this.repository);
  Future<void> call() => repository.seedDefaultCategories();
}
