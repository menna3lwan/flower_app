enum ProductStatus {
  inStock,
  outOfStock;

  static ProductStatus fromString(String? status) {
    switch (status) {
      case 'InStock':
        return inStock;
      case 'OutOfStock':
        return outOfStock;
      case null:
        return outOfStock;

      default:
        return outOfStock;
    }
  }
}