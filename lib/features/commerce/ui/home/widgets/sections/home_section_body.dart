import 'package:flutter/material.dart';

import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import '../home_scroll_physics.dart';
import 'section_state_box.dart';

Widget homeSectionBody({
  required HomeSectionLoadStatus status,
  required Widget Function() success,
}) {
  return AnimatedSwitcher(
    duration: homeFadeDuration,
    switchInCurve: Curves.easeOut,
    child: switch (status) {
      HomeSectionLoadStatus.failed => SectionStateBox.error(
          key: ValueKey(status),
          message: AppStrings.somethingWentWrong,
        ),
      HomeSectionLoadStatus.empty => SectionStateBox.empty(
          key: ValueKey(status),
          message: AppStrings.homeSectionEmpty,
        ),
      HomeSectionLoadStatus.success ||
      HomeSectionLoadStatus.unsupported =>
        KeyedSubtree(key: ValueKey(status), child: success()),
    },
  );
}
