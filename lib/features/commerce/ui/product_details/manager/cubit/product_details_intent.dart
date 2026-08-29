sealed class ProductDetailsIntent {}

final class GetProductByIdIntent extends ProductDetailsIntent {
  final String id;
  GetProductByIdIntent(this.id);
}