import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../../common/widgets/app_animated_loading.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/states/error_view.dart';
import '../../../../../core/base/operation_state.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimens.dart';
import '../../../../../core/localization/app_strings.dart';
import '../manager/cubit/product_details_cubit.dart';
import '../manager/cubit/product_details_state.dart';
import '../widgets/product_details_content.dart';
import '../widgets/product_image_slider.dart';
import '../widgets/product_images_slider_error.dart';
import '../widgets/product_images_slider_loading.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          final status = state.operationState.status;
          final product = state.operationState.data;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                toolbarHeight: 0,
                backgroundColor: AppColors.primaryLight,
                flexibleSpace: Stack(
                  children: [
                    // Slider Content
                    Positioned.fill(
                      child: switch (status) {
                        OperationStatus.idle ||
                        OperationStatus.loading =>
                        const ProductImagesSliderLoading(),

                        OperationStatus.success => ProductImageSlider(
                          images: product?.images ?? const [],
                        ),

                        OperationStatus.failure => ProductImagesSliderError(
                          message: AppStrings.errorGallery,
                        ),
                      },
                    ),

                    // Floating Custom Back Button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: IconButton(
                          icon: Transform.flip(
                            flipX: isRtl,
                            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: switch (status) {
                  OperationStatus.idle ||
                  OperationStatus.loading =>
                  const AppAnimatedLoading(),

                  OperationStatus.success => ProductDetailsContent(
                    product: product!,
                  ),

                  OperationStatus.failure => ErrorView(
                    message: AppStrings.errorProduct,
                  ),
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          final status = state.operationState.status;
          return Padding(
            padding: const EdgeInsets.all(AppDimens.space16),
            child: PrimaryButton(
              label: switch (status) {
                OperationStatus.idle ||
                OperationStatus.loading =>
                AppStrings.loading,

                OperationStatus.success ||
                OperationStatus.failure =>
                AppStrings.addToCart,
              },
              onPressed: status == OperationStatus.success ? () {} : null,
            ),
          ).animate().slideY(
            begin: 1,
            end: 0,
            curve: Curves.easeOutCubic,
            duration: 700.ms,
          );
        },
      ),
    );
  }
}