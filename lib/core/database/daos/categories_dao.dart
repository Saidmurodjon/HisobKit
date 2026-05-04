import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Stream<List<Category>> watchAllCategories() =>
      (select(categories)
            ..orderBy([(c) => OrderingTerm.asc(c.nameEn)]))
          .watch();

  Future<List<Category>> getAllCategories() =>
      (select(categories)
            ..orderBy([(c) => OrderingTerm.asc(c.nameEn)]))
          .get();

  Future<List<Category>> getCategoriesByType(String type) =>
      (select(categories)
            ..where((c) => c.type.equals(type))
            ..orderBy([(c) => OrderingTerm.asc(c.nameEn)]))
          .get();

  Stream<List<Category>> watchCategoriesByType(String type) =>
      (select(categories)
            ..where((c) => c.type.equals(type))
            ..orderBy([(c) => OrderingTerm.asc(c.nameEn)]))
          .watch();

  Future<Category?> getCategoryById(int id) =>
      (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<List<Category>> getSubcategories(int parentId) =>
      (select(categories)
            ..where((c) => c.parentId.equals(parentId)))
          .get();

  Future<int> insertCategory(CategoriesCompanion category) =>
      into(categories).insert(category);

  Future<bool> updateCategory(CategoriesCompanion category) =>
      update(categories).replace(category);

  Future<int> deleteCategory(int id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();
}
