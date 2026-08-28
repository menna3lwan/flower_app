import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../common/widgets/app_animated_loading.dart';
import '../../../../../common/widgets/app_search_bar.dart';
import '../../../../../common/widgets/selectable_tab_bar.dart';
import '../../../../../common/widgets/states/empty_state.dart';
import '../../../../../common/widgets/states/error_view.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimens.dart';
import '../../../../../core/localization/app_strings.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'package:get/get.dart';
import '../../widget/app_products_grid_view.dart';
import '../manager/cubit/categories_cubit.dart';
import '../manager/cubit/categories_intent.dart';
import '../manager/cubit/categories_state.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key, this.initialCategoryId});
  
  final String? initialCategoryId;

  @override
  Widget build(BuildContext context) {
    return _CategoriesViewBody(
      initialCategoryId: initialCategoryId ?? (Get.arguments is String ? Get.arguments as String : null),
    );
  }
}

class _CategoriesViewBody extends StatefulWidget {
  const _CategoriesViewBody({this.initialCategoryId});
  
  final String? initialCategoryId;

  @override
  State<_CategoriesViewBody> createState() => _CategoriesViewBodyState();
}

class _CategoriesViewBodyState extends State<_CategoriesViewBody> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().doIntent(GetCategoriesIntent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppSearchAppBar(hintText: AppStrings.search),

      body: SafeArea(
        child: BlocListener<CategoriesCubit, CategoriesState>(
          listenWhen: (previous, current) =>
              previous.categoriesState.status !=
                  current.categoriesState.status &&
              current.categoriesState.isSuccess,
          listener: (context, state) {
            final categories = state.categoriesState.data ?? [];
            if (categories.isNotEmpty && _selectedCategoryId == null) {
              final firstCatId = categories.first.id;
              setState(() {
                _selectedCategoryId = firstCatId;
              });
              context.read<CategoriesCubit>().doIntent(
                GetProductsByCategoryIdIntent(firstCatId),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space8),
            child: Column(
              children: [
                BlocBuilder<CategoriesCubit, CategoriesState>(
                  buildWhen: (previous, current) =>
                      previous.categoriesState != current.categoriesState,
                  builder: (context, state) {
                    final catState = state.categoriesState;
                    if (catState.isLoading || catState.isIdle) {
                      return const SizedBox(
                        height: AppDimens.space32,
                        child: Center(child: AppAnimatedLoading()),
                      );
                    }
                    if (catState.isFailure) {
                      return SizedBox(
                        height: AppDimens.space32,
                        child: Center(
                          child: ErrorView(message: AppStrings.errorCategories),
                        ),
                      );
                    }
                    if (catState.isSuccess) {
                      final categories = catState.data ?? [];
                      if (categories.isEmpty) return Center(child: ErrorView(message: AppStrings.errorCategories));

                      final Map<String, String> tabs = {
                        for (var cat in categories) cat.id: cat.name,
                      };

                      return SelectableTabBar(
                        tabs: tabs,
                        selectedTabId:
                            _selectedCategoryId ?? categories.first.id,
                        onTabChanged: (categoryId) {
                          setState(() {
                            _selectedCategoryId = categoryId;
                          });
                          context.read<CategoriesCubit>().doIntent(
                            GetProductsByCategoryIdIntent(categoryId),
                          );
                        },
                      );
                    }
                    return const SizedBox(height: AppDimens.space8);
                  },
                ),
                const Gap(AppDimens.space8),
                Expanded(
                  child: BlocBuilder<CategoriesCubit, CategoriesState>(
                    buildWhen: (previous, current) =>
                        previous.productsByCategoryIdState !=
                        current.productsByCategoryIdState,
                    builder: (context, state) {
                      final opState = state.productsByCategoryIdState;

                      if (opState.isIdle || opState.isLoading) {
                        return Center(child: AppAnimatedLoading());
                      }

                      if (opState.isFailure) {
                        return Center(
                          child: ErrorView(message: AppStrings.errorProducts),
                        );
                      }

                      if (opState.items.isEmpty && opState.isSuccess) {
                        return EmptyState(
                          message: AppStrings.emptyProducts,
                          icon: Icons.search_off_rounded,
                        );
                      }

                      return AppProductsGridView(
                        products: opState.items,
                        hasReachedMax: opState.hasReachedMax,
                        isFetchingMore: opState.isFetchingMore,
                        fetchMoreError: opState.fetchMoreError?.message,
                        onLoadMore: () {
                          if (_selectedCategoryId != null) {
                            context.read<CategoriesCubit>().doIntent(
                              LoadMoreProductsByCategoryIdIntent(
                                _selectedCategoryId!,
                              ),
                            );
                          }
                        },
                        onRetryLoadMore: () {
                          if (_selectedCategoryId != null) {
                            context.read<CategoriesCubit>().doIntent(
                              LoadMoreProductsByCategoryIdIntent(
                                _selectedCategoryId!,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton:
          SizedBox(
            width: AppDimens.space100,
            height: AppDimens.space32,
            child: FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: AppColors.primary,
              elevation: 4,
              shape: const StadiumBorder(),
              extendedPadding: EdgeInsets.zero,

              icon: const Icon(
                Icons.tune_rounded,
                size: AppDimens.iconSizeSmall,
                color: AppColors.white,
              ),

              label: Text(
                AppStrings.filter,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ).animate().slideY(
            begin: 5,
            end: 0,
            curve: Curves.easeOutCubic,
            duration: 700.ms,
          ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
