import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/home/presentation/bloc/home_cubit.dart';
import 'package:lumina_medical_center/features/home/presentation/bloc/home_state.dart';
import 'package:lumina_medical_center/features/home/presentation/widgets/home/home_dashboard_content.dart';
import 'package:lumina_medical_center/features/home/presentation/widgets/home/home_header.dart';
import 'package:lumina_medical_center/features/home/presentation/widgets/home/home_search_bar.dart';
import 'package:lumina_medical_center/features/home/presentation/widgets/home/home_search_results.dart';

import 'package:lumina_medical_center/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        getTopDoctorsUseCase: sl(),
        getUpcomingAppointmentUseCase: sl(),
        getUserUseCase: sl(),
        getAllBranchesUseCase: sl(),
      )..loadHomeData(),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == HomeStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage ?? "An error occurred"),
                    TextButton(
                      onPressed: () => context.read<HomeCubit>().loadHomeData(),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            final isSearching =
                state.searchQuery != null && state.searchQuery!.isNotEmpty;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing.m,
                    vertical: context.spacing.s,
                  ),
                  child: Column(
                    children: [
                      HomeHeader(
                        userName: state.userName,
                        userImage: state.userImageUrl ?? '',
                      ),
                      context.vSpaceM,

                      HomeSearchBar(
                        currentQuery: state.searchQuery ?? '',
                        onChanged: (val) =>
                            context.read<HomeCubit>().search(val),
                        onClear: () => context.read<HomeCubit>().clearSearch(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isSearching
                      ? HomeSearchResults(
                          doctors: state.topDoctors,
                          query: state.searchQuery!,
                        )
                      : HomeDashboardContent(
                          categories: state.categories,
                          topDoctors: state.topDoctors,
                          popularDoctors: state.topDoctors,
                          upcomingAppointment: state.upcomingAppointment,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
