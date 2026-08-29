import 'package:customer_app/core/constants/app_assets.dart';

/// Maps [CategoryEntity.iconName] to a Figma-matched SVG; Card and Gift share one glyph.
String categoryIconAssetFor(String iconName) => switch (iconName) {
      'local_florist' => AppAssets.categoryFlowersIcon,
      'card_giftcard' => AppAssets.categoryGiftIcon,
      'card_membership' => AppAssets.categoryGiftIcon,
      'diamond' => AppAssets.categoryDiamondIcon,
      _ => AppAssets.categoryFlowersIcon,
    };
