import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/app_animated_loading.dart';
import '../../../../../common/widgets/states/error_view.dart';
import '../../../../../core/base/operation_state.dart';
import '../../../../../core/constants/app_dimens.dart';
import '../../../../../core/localization/app_strings.dart';
import '../../../domain/entities/product_item_entity.dart';
import '../../widget/app_products_grid_view.dart';
import '../../widget/app_products_view_all_app_bar.dart';
import '../manager/cubit/best_seller_cubit.dart';
import '../manager/cubit/best_seller_state.dart';
import '../manager/cubit/best_selleter_intent.dart';

class BestSellerView extends StatelessWidget {
  const BestSellerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppProductsViewAllAppBar(
        onBackTap: () {},
        title: AppStrings.bestSeller,
        subtitle: AppStrings.bestSellerPageDescription,
      ),
      body: SafeArea(
        child: BlocBuilder<BestSellerCubit, BestSellerState>(
          builder: (context, state) {
            final status = state.operationState.status;
            final List<ProductItemEntity> products = state.operationState.items;

            return Padding(
              padding: const EdgeInsets.all(AppDimens.space8),
              child: switch(status) {
                OperationStatus.idle || OperationStatus.loading => Center(child: AppAnimatedLoading()),
                OperationStatus.success => AppProductsGridView(
                  products: products,
                  hasReachedMax: state.operationState.hasReachedMax,
                  isFetchingMore: state.operationState.isFetchingMore,
                  fetchMoreError: state.operationState.fetchMoreError?.message,
                  onLoadMore: () {
                    context.read<BestSellerCubit>().doIntent(LoadMoreBestSellerIntent());
                  },
                  onRetryLoadMore: () {
                    context.read<BestSellerCubit>().doIntent(LoadMoreBestSellerIntent());
                  },
                ),
                OperationStatus.failure => ErrorView(message: AppStrings.errorProducts),
              },
            );
          },
        ),
      ),
    );
  }
}
