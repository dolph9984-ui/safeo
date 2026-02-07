import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/view/search_page/widgets/search_page_search_bar.dart';
import 'package:securite_mobile/view/search_page/widgets/recent_searches_section.dart';
import 'package:securite_mobile/view/search_page/widgets/search_results_section.dart';
import 'package:securite_mobile/viewmodel/search_page_viewmodel.dart';

class SearchPageView extends StatelessWidget {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchPageViewModel(),
      child: const _SearchPageContent(),
    );
  }
}

class _SearchPageContent extends StatelessWidget {
  const _SearchPageContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchPageViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: Row(
                spacing: 12,
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: SvgPicture.asset(
                      'assets/icons/arrow_left.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        AppColors.foreground,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Hero(
                      tag: 'search_bar',
                      child: Material(
                        type: MaterialType.transparency,
                        child: SearchPageSearchBar(
                          controller: vm.searchController,
                          hintText: 'Rechercher un fichier...',
                          onClear: vm.clearSearch,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: vm.hasQuery
                ? SearchResultsSection(
                    results: vm.searchResults,
                    searchQuery: vm.searchController.text,
                  )
                : RecentSearchesSection(
                    recentFiles: vm.recentSearches,
                    onClearAll: vm.clearRecentSearches,
                  ),
          ),
        ],
      ),
    );
  }
}