sealed class ProductDetailsIntent {}

final class GetProductByIdIntent extends ProductDetailsIntent {
  String id;
  GetProductByIdIntent(this.id);
}