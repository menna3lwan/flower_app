import '../../../../core/domain/entities/category_entity.dart';
import '../../../../core/domain/entities/occasion_entity.dart';
import '../../../../core/domain/entities/product_entity.dart';
import 'package:customer_app/core/error/exceptions.dart';

abstract interface class CatalogLocalDataSource {
  Future<List<CategoryEntity>> getCategories();
  Future<List<OccasionEntity>> getOccasions();
  Future<List<ProductEntity>> getAllProducts();
  Future<ProductEntity> getProductById(String id);

  Future<List<String>> occasionProductIds(String occasionId);
}

class CatalogLocalDataSourceImpl implements CatalogLocalDataSource {
  static const _simulatedLatency = Duration(milliseconds: 500);

  static const _categories = [
    CategoryEntity(id: 'cat-flowers', name: 'Flowers', iconName: 'local_florist'),
    CategoryEntity(id: 'cat-gift', name: 'Gift', iconName: 'card_giftcard'),
    CategoryEntity(id: 'cat-card', name: 'Card', iconName: 'card_membership'),
    CategoryEntity(id: 'cat-jewellery', name: 'Jewellery', iconName: 'diamond'),
    CategoryEntity(id: 'cat-vases', name: 'Vases', iconName: 'water_drop'),
    CategoryEntity(id: 'cat-boxes', name: 'Boxes', iconName: 'inventory_2'),
  ];

  static const _occasions = [
    OccasionEntity(id: 'occ-wedding', name: 'Wedding', imageUrl: ''),
    OccasionEntity(id: 'occ-birthday', name: 'Birthday', imageUrl: ''),
    OccasionEntity(id: 'occ-graduation', name: 'Graduation', imageUrl: ''),
    OccasionEntity(id: 'occ-anniversary', name: 'Anniversary', imageUrl: ''),
  ];

  static final _products = <ProductEntity>[
    const ProductEntity(
      id: 'prod-1',
      name: 'Sunny',
      imageUrl: '',
      price: 600,
      rating: 4.8,
      categoryId: 'cat-flowers',
      description:
          'A cheerful hand-tied bouquet of sunflowers and seasonal greenery, wrapped in natural kraft paper.',
      includes: ['3 Sunflowers', 'Seasonal greenery', 'Kraft wrap'],
    ),
    const ProductEntity(
      id: 'prod-2',
      name: 'Red roses',
      imageUrl: '',
      price: 600,
      originalPrice: 800,
      discountPercentage: 20,
      rating: 4.9,
      categoryId: 'cat-flowers',
      description: '15 Pink rose Bouquet — Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      includes: ['15 Pink roses', 'Wrapping paper', 'Greeting card'],
    ),
    const ProductEntity(
      id: 'prod-3',
      name: 'Spring vase',
      imageUrl: '',
      price: 600,
      rating: 4.6,
      categoryId: 'cat-vases',
      description: 'A mixed spring arrangement presented in a glass vase.',
      includes: ['Mixed spring flowers', 'Glass vase'],
    ),
    const ProductEntity(
      id: 'prod-4',
      name: 'Tulip bunch',
      imageUrl: '',
      price: 450,
      originalPrice: 550,
      discountPercentage: 18,
      rating: 4.5,
      categoryId: 'cat-flowers',
      description: 'Fresh tulips in a soft pastel mix.',
      includes: ['12 Tulips', 'Wrapping paper'],
    ),
    const ProductEntity(
      id: 'prod-5',
      name: 'Gift box',
      imageUrl: '',
      price: 350,
      rating: 4.3,
      categoryId: 'cat-gift',
      description: 'A curated gift box paired with a small floral accent.',
      includes: ['Gift box', 'Ribbon', 'Mini bouquet'],
    ),
    const ProductEntity(
      id: 'prod-6',
      name: 'Greeting card',
      imageUrl: '',
      price: 80,
      rating: 4.1,
      categoryId: 'cat-card',
      description: 'A hand-illustrated greeting card for any occasion.',
      includes: ['1 Card', '1 Envelope'],
    ),
    const ProductEntity(
      id: 'prod-7',
      name: 'Charm necklace',
      imageUrl: '',
      price: 900,
      rating: 4.7,
      categoryId: 'cat-jewellery',
      description: 'A delicate flower-charm necklace, gift-boxed.',
      includes: ['Necklace', 'Gift box'],
    ),
    const ProductEntity(
      id: 'prod-8',
      name: 'Wedding bouquet',
      imageUrl: '',
      price: 1200,
      rating: 5,
      categoryId: 'cat-flowers',
      description: 'A romantic white and blush bridal bouquet.',
      includes: ['Bridal bouquet', 'Ribbon wrap'],
    ),
    const ProductEntity(
      id: 'prod-9',
      name: 'Birthday burst',
      imageUrl: '',
      price: 500,
      originalPrice: 620,
      discountPercentage: 15,
      rating: 4.4,
      categoryId: 'cat-flowers',
      description: 'A bright, colorful bouquet made for celebrating.',
      includes: ['Mixed bright flowers', 'Balloon accent'],
    ),
    const ProductEntity(
      id: 'prod-10',
      name: 'Graduation cheer',
      imageUrl: '',
      price: 550,
      rating: 4.6,
      categoryId: 'cat-flowers',
      description: 'Celebratory bouquet with a graduation cap accent.',
      includes: ['Mixed flowers', 'Mini graduation cap'],
    ),
  ];

  static const _occasionProductIds = <String, List<String>>{
    'occ-wedding': ['prod-8', 'prod-3'],
    'occ-birthday': ['prod-9', 'prod-1'],
    'occ-graduation': ['prod-10', 'prod-4'],
    'occ-anniversary': ['prod-2', 'prod-7'],
  };

  @override
  Future<List<CategoryEntity>> getCategories() async {
    await Future.delayed(_simulatedLatency);
    return _categories;
  }

  @override
  Future<List<OccasionEntity>> getOccasions() async {
    await Future.delayed(_simulatedLatency);
    return _occasions;
  }

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    await Future.delayed(_simulatedLatency);
    return _products;
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    await Future.delayed(_simulatedLatency);
    return _products.firstWhere(
      (product) => product.id == id,
      orElse: () => throw const ServerException('Product not found.'),
    );
  }

  @override
  Future<List<String>> occasionProductIds(String occasionId) async {
    return _occasionProductIds[occasionId] ?? const [];
  }
}
