import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../common/widgets/app_animated_loading.dart';
import '../../../../../common/widgets/app_search_bar.dart';
import '../../../../../common/widgets/selectable_tab_bar.dart';
import '../../../../../common/widgets/states/empty_state.dart';
import '../../../../../common/widgets/states/error_view.dart';
import '../../../../../core/constants/app_dimens.dart';
import 'package:get/get.dart';
import '../../../../../core/localization/app_strings.dart';
import '../../widget/app_products_grid_view.dart';
import '../../widget/app_products_view_all_app_bar.dart';
import '../manager/cubit/occasions_cubit.dart';
import '../manager/cubit/occasions_intent.dart';
import '../manager/cubit/occasions_state.dart';


class OccasionsView extends StatelessWidget {
  const OccasionsView({super.key, this.initialOccasionId});

  final String? initialOccasionId;

  @override
  Widget build(BuildContext context) {
    return _OccasionsViewBody(
      initialOccasionId: initialOccasionId ?? (Get.arguments is String ? Get.arguments as String : null),
    );
  }
}

class _OccasionsViewBody extends StatefulWidget {
  const _OccasionsViewBody({this.initialOccasionId});

  final String? initialOccasionId;

  @override
  State<_OccasionsViewBody> createState() => _OccasionsViewBodyState();
}

class _OccasionsViewBodyState extends State<_OccasionsViewBody> {
  String? _selectedOccasionId;

  @override
  void initState() {
    super.initState();
    _selectedOccasionId = widget.initialOccasionId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OccasionsCubit>().doIntent(GetOccasionsIntent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppProductsViewAllAppBar(
        onBackTap: () {},
        title: AppStrings.occasion,
        subtitle: AppStrings.occasionsPageDescription,
      ),

      body: SafeArea(
        child: BlocListener<OccasionsCubit, OccasionsState>(
          listenWhen: (previous, current) =>
          previous.occasionsState.status !=
              current.occasionsState.status &&
              current.occasionsState.isSuccess,
          listener: (context, state) {
            final occasions = state.occasionsState.data ?? [];
            if (occasions.isNotEmpty && _selectedOccasionId == null) {
              final firstOccasionId = occasions.first.id;
              setState(() {
                _selectedOccasionId = firstOccasionId;
              });
              context.read<OccasionsCubit>().doIntent(
                GetProductsByOccasionIdIntent(firstOccasionId),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space8),
            child: Column(
              children: [
                BlocBuilder<OccasionsCubit, OccasionsState>(
                  buildWhen: (previous, current) =>
                  previous.occasionsState != current.occasionsState,
                  builder: (context, state) {
                    final occasionState = state.occasionsState;
                    if (occasionState.isLoading || occasionState.isIdle) {
                      return const SizedBox(
                        height: AppDimens.space32,
                        child: Center(child: AppAnimatedLoading()),
                      );
                    }
                    if (occasionState.isFailure) {
                      return SizedBox(
                        height: AppDimens.space32,
                        child: Center(
                          child: ErrorView(message: AppStrings.errorOccasions),
                        ),
                      );
                    }
                    if (occasionState.isSuccess) {
                      final occasions = occasionState.data ?? [];
                      if (occasions.isEmpty) return Center(child: ErrorView(message: AppStrings.errorOccasions));

                      final Map<String, String> tabs = {
                        for (var occasion in occasions) occasion.id: occasion.name,
                      };

                      return SelectableTabBar(
                        tabs: tabs,
                        selectedTabId:
                        _selectedOccasionId ?? occasions.first.id,
                        onTabChanged: (occasionId) {
                          setState(() {
                            _selectedOccasionId = occasionId;
                          });
                          context.read<OccasionsCubit>().doIntent(
                            GetProductsByOccasionIdIntent(occasionId),
                          );
                        },
                      );
                    }
                    return const SizedBox(height: AppDimens.space8);
                  },
                ),
                const Gap(AppDimens.space8),
                Expanded(
                  child: BlocBuilder<OccasionsCubit, OccasionsState>(
                    buildWhen: (previous, current) =>
                    previous.productsByOccasionIdState !=
                        current.productsByOccasionIdState,
                    builder: (context, state) {
                      final opState = state.productsByOccasionIdState;

                      if (opState.isIdle || opState.isLoading) {
                        return const Center(child: AppAnimatedLoading());
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
                          if (_selectedOccasionId != null) {
                            context.read<OccasionsCubit>().doIntent(
                              LoadMoreProductsByOccasionIdIntent(
                                _selectedOccasionId!,
                              ),
                            );
                          }
                        },
                        onRetryLoadMore: () {
                          if (_selectedOccasionId != null) {
                            context.read<OccasionsCubit>().doIntent(
                              LoadMoreProductsByOccasionIdIntent(
                                _selectedOccasionId!,
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
    );
  }
}
