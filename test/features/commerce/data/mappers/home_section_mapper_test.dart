import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/features/commerce/data/mappers/home_section_mapper.dart';
import 'package:customer_app/features/commerce/data/models/home_section_dto.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_type.dart';

void main() {
  test('maps a known type string to its HomeSectionType', () {
    const dto = HomeSectionDto(
      id: 5,
      type: 'ProductsCarousel',
      index: 3,
      isActive: true,
      title: 'Wedding picks',
      occasionId: 7,
      categoryId: null,
    );

    final entity = dto.toEntity();

    expect(entity.id, '5');
    expect(entity.type, HomeSectionType.productsCarousel);
    expect(entity.order, 3);
    expect(entity.isActive, isTrue);
    expect(entity.title, 'Wedding picks');
    expect(entity.occasionId, '7');
    expect(entity.categoryId, isNull);
  });

  test('an unrecognized type string degrades to unknown, not a throw', () {
    const dto = HomeSectionDto(
      id: 9,
      type: 'FutureSectionTypeNotYetSupported',
      index: 0,
      isActive: true,
    );

    expect(dto.toEntity().type, HomeSectionType.unknown);
  });
}
