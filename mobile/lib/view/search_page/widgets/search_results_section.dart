// search_results_section.dart
import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/view/search_page/widgets/search_file_item.dart';

class SearchResultsSection extends StatelessWidget {
  final List<Document> results;
  final String searchQuery;
  final Function(Document)? onFileTap;

  const SearchResultsSection({
    super.key,
    required this.results,
    required this.searchQuery,
    this.onFileTap,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.mutedForeground,
            ),
            Text(
              'Aucun résultat trouvé',
              style: TextStyle(
                fontFamily: AppFonts.productSansMedium,
                fontSize: 16,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        Text(
          '${results.length} résultat${results.length > 1 ? 's' : ''}',
          style: TextStyle(
            fontFamily: AppFonts.zalandoSans,
            fontSize: 16,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          spacing: 16,
          children: results
              .map((file) => SearchFileItem(
                    file: file,
                    searchQuery: searchQuery,
                    onTap: onFileTap != null ? () => onFileTap!(file) : null,
                  ))
              .toList(),
        ),
      ],
    );
  }
}