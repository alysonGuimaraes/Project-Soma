import 'package:project_soma/core/connection/database_connection.dart';
import 'package:project_soma/features/category/domain/entities/category_entity.dart';
import 'package:project_soma/features/category/domain/repositories/i_category_repository.dart';

class CategoryRepositoryImpl extends ICategoryRepository {
  final DatabaseConnection databaseConnection;

  CategoryRepositoryImpl(this.databaseConnection);

  @override
  Future<void> createCategory(CategoryEntity category) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCategory(String id) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryEntity>> getAllCategories() {
    // TODO: implement getAllCategories
    throw UnimplementedError();
  }

  @override
  Future<CategoryEntity?> getCategoryById(String id) {
    // TODO: implement getCategoryById
    throw UnimplementedError();
  }

  @override
  Future<void> updateCategory(CategoryEntity category) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }
}
