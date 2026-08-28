import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/constants/app_colors.dart';

class ProductImageSlider extends StatelessWidget {
  const ProductImageSlider({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });

  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        return Stack(
          alignment: Alignment.center,
          children: [
            const ColoredBox(
              color: AppColors.primaryLight,
            ),

            CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.contain,
                  ),
                );
              },
              options: CarouselOptions(
                height: height,
                viewportFraction: 1,
                enlargeCenterPage: true,
                enlargeFactor: 0.5,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  onPageChanged(index);
                },
              ),
            ),

            if (images.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: currentIndex,
                    count: images.length,
                    effect: const WormEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.disabled,
                      spacing: 8,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}