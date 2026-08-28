sealed class CategoriesIntent {}

final class GetProductsByCategoryIdIntent extends CategoriesIntent {
  String categoryId;
  GetProductsByCategoryIdIntent(this.categoryId);
}

final class GetCategoriesIntent extends CategoriesIntent {}

final class LoadMoreProductsByCategoryIdIntent extends CategoriesIntent {
  String categoryId;
  LoadMoreProductsByCategoryIdIntent(this.categoryId);
}