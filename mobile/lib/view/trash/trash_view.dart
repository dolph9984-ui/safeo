import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/view/trash/widgets/trash_list.dart';
import 'package:securite_mobile/viewmodel/trash_viewmodel.dart';

class TrashView extends StatelessWidget {
  const TrashView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TrashViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(),
        title: Text(
          'Corbeille',
          style: TextStyle(
            fontFamily: AppFonts.zalandoSans,
            fontSize: 16,
            color: AppColors.foreground,
          ),
        ),
        actions: [
          if (vm.trashedFiles.isNotEmpty)
            IconButton(
              onPressed: () => vm.showTrashOptionsSheet(context),
              icon: SvgPicture.asset(
                'assets/icons/more_vert.svg',
                colorFilter: ColorFilter.mode(
                  AppColors.foreground,
                  BlendMode.srcIn,
                ),
                height: 24,
                width: 24,
              ),
            ),
        ],
      ),
      body: vm.trashedFiles.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                if (vm.isSelectionMode)
                  _buildSelectionHeader(context, vm),
                
                Expanded(
                  child: TrashList(
                    trashedFiles: vm.trashedFiles,
                    selectedIds: vm.selectedFileIds,
                    isSelectionMode: vm.isSelectionMode,
                    onItemTap: vm.onItemTap,
                    onItemLongPress: vm.onItemLongPress,
                    onMenuTap: (id) => vm.showFileOptionsSheet(context, id),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete_outline,
            size: 80,
            color: AppColors.mutedForeground,
          ),
          const SizedBox(height: 16),
          Text(
            'La corbeille est vide',
            style: TextStyle(
              fontFamily: AppFonts.productSansMedium,
              fontSize: 16,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les fichiers supprimés apparaîtront ici',
            style: TextStyle(
              fontFamily: AppFonts.productSansRegular,
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionHeader(BuildContext context, TrashViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        border: Border(
          bottom: BorderSide(
            color: AppColors.buttonDisabled,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: vm.exitSelectionMode,
            icon: Icon(Icons.close, color: AppColors.foreground),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${vm.selectedFileIds.length} sélectionné(s)',
              style: TextStyle(
                fontFamily: AppFonts.productSansMedium,
                fontSize: 15,
                color: AppColors.foreground,
              ),
            ),
          ),
          TextButton(
            onPressed: () => vm.restoreSelectedFiles(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text('Restaurer'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => vm.deleteSelectedFiles(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.destructive,
            ),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}