import 'package:flutter/widgets.dart';

import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';

/// One renderer per known [HomeSectionContentEntity] subtype — a new section only needs a new renderer registered in [HomeSectionRendererRegistry].
abstract interface class HomeSectionRenderer {
  bool supports(HomeSectionContentEntity section);

  Widget build(BuildContext context, HomeSectionContentEntity section);
}
