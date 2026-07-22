import '../entities/category_entity.dart';

abstract class ICategoryRepository {
  Future<void> createCategory(CategoryEntity category);

  Future<List<CategoryEntity>> getAllCategories();
  Future<CategoryEntity?> getCategoryById(String id);

  Future<void> updateCategory(CategoryEntity category);

  Future<void> deleteCategory(String id);
}
