import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/features/commerce/data/models/home_section_dto.dart';
import 'package:customer_app/features/commerce/data/models/home_sections_response_dto.dart';

void main() {
  group('HomeSectionDto.fromJson', () {
    test('parses a full section', () {
      final dto = HomeSectionDto.fromJson({
        'id': 1,
        'type': 'Categories',
        'index': 0,
        'isActive': true,
        'title': 'Shop by category',
        'occasionId': null,
        'categoryId': null,
      });

      expect(dto.id, 1);
      expect(dto.type, 'Categories');
      expect(dto.index, 0);
      expect(dto.isActive, isTrue);
      expect(dto.title, 'Shop by category');
    });

    test('defaults missing optional fields safely', () {
      final dto = HomeSectionDto.fromJson({'id': 2});

      expect(dto.type, '');
      expect(dto.index, 0);
      expect(dto.isActive, isFalse);
      expect(dto.title, isNull);
    });
  });

  group('HomeSectionsResponseDto.fromJson', () {
    test('drops a malformed list entry instead of failing the whole response',
        () {
      final response = HomeSectionsResponseDto.fromJson({
        'isSuccess': true,
        'data': [
          {'id': 1, 'type': 'Categories', 'index': 0, 'isActive': true},
          'not-a-map',
          {'id': 3, 'type': 'BestSeller', 'index': 1, 'isActive': true},
        ],
      });

      expect(response.isSuccess, isTrue);
      expect(response.sections, hasLength(2));
      expect(response.sections.map((s) => s.id), [1, 3]);
    });

    test('missing/non-list data yields an empty section list', () {
      final response = HomeSectionsResponseDto.fromJson({'isSuccess': false});

      expect(response.isSuccess, isFalse);
      expect(response.sections, isEmpty);
    });
  });
}
