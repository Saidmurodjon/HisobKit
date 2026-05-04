import '../database/app_database.dart';

/// Returns the category name in the given language code.
extension CategoryLocalizedName on Category {
  String localizedName(String language) {
    switch (language) {
      case 'uz':
        return nameUz;
      case 'ru':
        return nameRu;
      default:
        return nameEn;
    }
  }
}
