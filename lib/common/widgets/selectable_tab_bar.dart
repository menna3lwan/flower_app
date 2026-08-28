import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

class SelectableTabBar extends StatefulWidget {
  const SelectableTabBar({
    super.key,
    required this.tabs,
    required this.selectedTabId,
    this.onTabChanged,
  });

  /// Map of Tab ID to Tab Label
  final Map<String, String> tabs;
  final String selectedTabId;
  final ValueChanged<String>? onTabChanged;

  @override
  State<SelectableTabBar> createState() => _SelectableTabBarState();
}

class _SelectableTabBarState extends State<SelectableTabBar> {
  @override
  Widget build(BuildContext context) {
    final tabEntries = widget.tabs.entries.toList();

    return SizedBox(
      height: AppDimens.space32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabEntries.length,
        separatorBuilder: (context, index) => const Gap(AppDimens.space24),
        itemBuilder: (context, index) {
          final entry = tabEntries[index];
          final isSelected = entry.key == widget.selectedTabId;
          return GestureDetector(
            onTap: () {
              widget.onTabChanged?.call(entry.key);
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: AppDimens.space4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.placeholderGray.withOpacity(0.5),
                    width: AppDimens.space4,
                  ),
                ),
              ),
              child: Text(
                entry.value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.placeholderGray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
