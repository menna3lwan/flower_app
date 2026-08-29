import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/common/widgets/states/empty_state.dart';
import 'package:customer_app/common/widgets/states/error_view.dart';
import 'package:customer_app/common/widgets/states/loading_view.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/di/injector.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import '../mappers/home_failure_message.dart';
import '../manager/home_cubit.dart';
import '../manager/home_state.dart';
import '../registry/home_section_renderer_registry.dart';
import '../widgets/chrome/delivery_location_row.dart';
import '../widgets/chrome/home_bottom_nav.dart';
import '../widgets/chrome/home_logo_search_row.dart';

/// Server-driven Home screen: renders whatever sections `/home/sections` returns, in the order given.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _registry = sl<HomeSectionRendererRegistry>();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const HomeBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Figma-verified gap from the status bar to the logo row.
            const SizedBox(height: AppDimens.space16),
            const HomeLogoSearchRow(),
            const SizedBox(height: AppDimens.space16),
            const DeliveryLocationRow(),
            const SizedBox(height: AppDimens.space16),
            Expanded(
              child: BlocConsumer<HomeCubit, HomeState>(
                listener: _handleRefreshFailure,
                builder: (context, state) => switch (state) {
                  HomeInitial() || HomeLoading() => const LoadingView(),
                  HomeEmpty() => EmptyState(
                      message: AppStrings.homeEmptyState,
                      icon: Icons.local_florist_outlined,
                    ),
                  HomeError(:final failure) => ErrorView(
                      message: failure.homeMessage,
                      retryLabel: AppStrings.retry,
                      onRetry: () => context.read<HomeCubit>().loadHome(),
                    ),
                  HomeLoaded(:final sections) => _HomeSectionsList(
                      sections: sections,
                      registry: _registry,
                      onRefresh: () => context.read<HomeCubit>().refreshHome(),
                    ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRefreshFailure(BuildContext context, HomeState state) {
    if (state is HomeLoaded && state.refreshFailure != null) {
      context.showErrorSnackBar(state.refreshFailure!.homeMessage);
      context.read<HomeCubit>().consumeRefreshFailure();
    }
  }
}

class _HomeSectionsList extends StatelessWidget {
  const _HomeSectionsList({
    required this.sections,
    required this.registry,
    required this.onRefresh,
  });

  final List<HomeSectionContentEntity> sections;
  final HomeSectionRendererRegistry registry;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: ListView.separated(
        // No top padding: the gap after DeliveryLocationRow already supplies it (see HomeView).
        padding: const EdgeInsets.only(bottom: AppDimens.space16),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppDimens.space24),
        itemBuilder: (context, index) =>
            registry.build(context, sections[index]),
      ),
    );
  }
}
