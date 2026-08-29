import 'package:customer_app/core/constants/app_assets.dart';

/// Maps [CategoryEntity.iconName] (kept Flutter-free in the domain layer) to a concrete, Figma-matched SVG asset.
/// Card and Gift share the same glyph — the source Figma design uses one icon for both chips.
String categoryIconAssetFor(String iconName) => switch (iconName) {
      'local_florist' => AppAssets.categoryFlowersIcon,
      'card_giftcard' => AppAssets.categoryGiftIcon,
      'card_membership' => AppAssets.categoryGiftIcon,
      'diamond' => AppAssets.categoryDiamondIcon,
      _ => AppAssets.categoryFlowersIcon,
    };
