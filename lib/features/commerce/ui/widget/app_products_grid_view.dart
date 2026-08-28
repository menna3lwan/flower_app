import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/product_item_entity.dart';
import 'product_card.dart';

class AppProductsGridView extends StatefulWidget {
  const AppProductsGridView({
    super.key,
    required this.products,
    this.hasReachedMax = true,
    this.isFetchingMore = false,
    this.fetchMoreError,
    this.onLoadMore,
    this.onRetryLoadMore,
  });

  final List<ProductItemEntity> products;
  final bool hasReachedMax;
  final bool isFetchingMore;
  final String? fetchMoreError;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRetryLoadMore;

  @override
  State<AppProductsGridView> createState() => _AppProductsGridViewState();
}

class _AppProductsGridViewState extends State<AppProductsGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!widget.hasReachedMax &&
          !widget.isFetchingMore &&
          widget.fetchMoreError == null) {
        widget.onLoadMore?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimens.space8,
              mainAxisSpacing: AppDimens.space12,
              childAspectRatio: 0.606,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = widget.products[index];
              return Card(
                elevation: 0,
                color: AppColors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: AppColors.placeholderGray,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.space8),
                  child: ProductCard(
                    product: product,
                    width: double.infinity,
                    onAddToCart: () {},
                    onTap: () {},
                  ),
                ),
              );
            }, childCount: widget.products.length),
          ),
        ),
        if (widget.isFetchingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimens.space16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
        if (widget.fetchMoreError != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.space16),
              child: Column(
                children: [
                  Text(widget.fetchMoreError!, textAlign: TextAlign.center),
                  const SizedBox(height: AppDimens.space8),
                  ElevatedButton(
                    onPressed: widget.onRetryLoadMore,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
