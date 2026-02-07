import 'package:flutter/material.dart';
import 'package:securite_mobile/view/trash/widgets/trash_item.dart';
import 'package:securite_mobile/view/trash/widgets/trashed_file.dart';

class TrashList extends StatelessWidget {
  final List<TrashedFile> trashedFiles;
  final Set<String> selectedIds;
  final bool isSelectionMode;
  final Function(String id) onItemTap;
  final Function(String id) onItemLongPress;
  final Function(String id) onMenuTap;

  const TrashList({
    super.key,
    required this.trashedFiles,
    required this.selectedIds,
    required this.isSelectionMode,
    required this.onItemTap,
    required this.onItemLongPress,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: trashedFiles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final file = trashedFiles[index];
        final isSelected = selectedIds.contains(file.id);

        return TrashItem(
          trashedFile: file,
          isSelected: isSelected,
          isSelectionMode: isSelectionMode,
          onTap: () => onItemTap(file.id),
          onLongPress: () => onItemLongPress(file.id),
          onMenuTap: () => onMenuTap(file.id),
        );
      },
    );
  }
}