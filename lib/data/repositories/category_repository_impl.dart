import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../local/daos/category_dao.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDao _categoryDao;
  final Uuid _uuid = const Uuid();

  CategoryRepositoryImpl(this._categoryDao);

  @override
  Future<List<Category>> getAllCategories() async {
    final categories = await _categoryDao.getAllCategories();
    return categories.map((c) => c.toEntity()).toList();
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    final category = await _categoryDao.getCategoryById(id);
    return category?.toEntity();
  }

  @override
  Future<void> addCategory(Category category) async {
    await _categoryDao.insertCategory(category.toCompanion());
  }

  @override
  Future<void> updateCategory(Category category) async {
    await _categoryDao.updateCategory(category.toCompanion());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _categoryDao.deleteCategory(id);
  }

  @override
  Future<void> seedDefaultCategories() async {
    final existingCategories = await getAllCategories();
    if (existingCategories.isEmpty) {
      for (final entry in AppConstants.defaultCategories.entries) {
        final categoryData = entry.value;
        final category = Category(
          id: _uuid.v4(),
          name: categoryData['name'] as String,
          icon: categoryData['icon'] as String,
          color: categoryData['color'] as int,
          isCustom: false,
          createdAt: DateTime.now().toUtc(),
        );
        await addCategory(category);
      }
    }
  }
}
