import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_dimens.dart';

const Duration homeFadeDuration = Duration(milliseconds: 200);

/// Platform-native Home scroll feel — bounce on iOS, clamp on Android.
ScrollPhysics homeScrollPhysics(
  BuildContext context, {
  bool alwaysScrollable = false,
}) {
  final parent = switch (Theme.of(context).platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => const BouncingScrollPhysics(),
    _ => const ClampingScrollPhysics(),
  };
  return alwaysScrollable
      ? AlwaysScrollableScrollPhysics(parent: parent)
      : parent;
}

/// Horizontal Home carousel with independent physics so it doesn't fight the vertical list.
class HomeHorizontalScroller extends StatelessWidget {
  const HomeHorizontalScroller({
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  final double height;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        primary: false,
        physics: homeScrollPhysics(context),
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
        itemCount: itemCount,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppDimens.space16),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
