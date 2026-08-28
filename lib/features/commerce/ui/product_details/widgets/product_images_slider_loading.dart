import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/constants/app_colors.dart';

class ProductImagesSliderLoading extends StatelessWidget {
  const ProductImagesSliderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.grey.shade100,
          )
              .animate(
                onPlay: (controller) => controller.repeat(),
              )
              .shimmer(
                duration: 1400.ms,
              ),
        ),
        Positioned(
          bottom: 16,
          child: Row(
            children: List.generate(
              4,
              (index) => Container(
                width: index == 0 ? 10 : 8,
                height: index == 0 ? 10 : 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 0 ? AppColors.primary : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
