sealed class OccasionsIntent {}

final class GetProductsByOccasionIdIntent extends OccasionsIntent {
  String occasionId;
  GetProductsByOccasionIdIntent(this.occasionId);
}

final class GetOccasionsIntent extends OccasionsIntent {}

final class LoadMoreProductsByOccasionIdIntent extends OccasionsIntent {
  String occasionId;
  LoadMoreProductsByOccasionIdIntent(this.occasionId);
}