import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/viewmodel/shared_files_viewmodel.dart';

class FilterBottomSheet extends StatelessWidget {
  final FileFilter currentFilter;
  final Function(FileFilter) onFilterSelected;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
              child: Row(
                children: [
                  Text(
                    'Filtrer par',
                    style: TextStyle(
                      fontFamily: AppFonts.productSansMedium,
                      fontSize: 16,
                      color: AppColors.foreground,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColors.foreground),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: AppColors.buttonDisabled),

            // Liste des filtres avec scroll
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...FileFilter.values.map((filter) {
                      final isSelected = filter == currentFilter;
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          onFilterSelected(filter);
                        },
                        child: Ink(
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    filter.label,
                                    style: TextStyle(
                                      fontFamily: isSelected 
                                          ? AppFonts.productSansMedium 
                                          : AppFonts.productSansRegular,
                                      fontSize: 15,
                                      color: isSelected 
                                          ? AppColors.primary 
                                          : AppColors.foreground,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}