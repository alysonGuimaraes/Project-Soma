import '../entities/category.dart';

abstract class ICategoryRepository {
  Future<List<CategoryEntity>> getAllCategories();

  Future<CategoryEntity?> getCategoryById(String id);

  Future<void> createCategory(CategoryEntity category);

  Future<void> updateCategory(CategoryEntity category);

  Future<void> deleteCategory(String id);
}
