import 'package:flutter/material.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/view/trash/widgets/trashed_file.dart';
import 'package:securite_mobile/view/widgets/app_bottom_sheet.dart';
import 'package:securite_mobile/view/widgets/bottom_sheet_item.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/view/widgets/success_snackbar.dart';

class TrashViewModel extends ChangeNotifier {
  List<TrashedFile> _trashedFiles = [];
  Set<String> _selectedFileIds = {};
  bool _isSelectionMode = false;

  List<TrashedFile> get trashedFiles => _trashedFiles;

  Set<String> get selectedFileIds => _selectedFileIds;

  bool get isSelectionMode => _isSelectionMode;

  TrashViewModel() {
    _loadMockData();
  }

  // Mock
  void _loadMockData() {
    final now = DateTime.now();
    _trashedFiles = [
      TrashedFile(
        id: '1',
        fileName: 'Contrat_entreprise.pdf',
        fileSize: 2.5,
        fileType: FileTypeEnum.pdf,
        deletedAt: now.subtract(Duration(days: 5)),
        deletionDate: now.add(Duration(days: 25)),
      ),
      TrashedFile(
        id: '2',
        fileName: 'Photo_vacances.jpg',
        fileSize: 1.8,
        fileType: FileTypeEnum.image,
        deletedAt: now.subtract(Duration(days: 12)),
        deletionDate: now.add(Duration(days: 18)),
      ),
      TrashedFile(
        id: '3',
        fileName: 'Presentation_projet.pptx',
        fileSize: 5.2,
        fileType: FileTypeEnum.document,
        deletedAt: now.subtract(Duration(days: 3)),
        deletionDate: now.add(Duration(days: 27)),
      ),
      TrashedFile(
        id: '4',
        fileName: 'Rapport_financier.xlsx',
        fileSize: 0.9,
        fileType: FileTypeEnum.csv,
        deletedAt: now.subtract(Duration(days: 20)),
        deletionDate: now.add(Duration(days: 10)),
      ),
      TrashedFile(
        id: '5',
        fileName: 'Video_formation.mp4',
        fileSize: 15.3,
        fileType: FileTypeEnum.other,
        deletedAt: now.subtract(Duration(days: 1)),
        deletionDate: now.add(Duration(days: 29)),
      ),
    ];
    notifyListeners();
  }

  // Gestion de la sélection
  void onItemTap(String id) {
    if (_isSelectionMode) {
      if (_selectedFileIds.contains(id)) {
        _selectedFileIds.remove(id);
      } else {
        _selectedFileIds.add(id);
      }

      if (_selectedFileIds.isEmpty) {
        _isSelectionMode = false;
      }
      notifyListeners();
    }
  }

  void onItemLongPress(String id) {
    if (!_isSelectionMode) {
      _isSelectionMode = true;
      _selectedFileIds.add(id);
      notifyListeners();
    }
  }

  void exitSelectionMode() {
    _isSelectionMode = false;
    _selectedFileIds.clear();
    notifyListeners();
  }

  void selectAll() {
    _selectedFileIds = _trashedFiles.map((f) => f.id).toSet();
    notifyListeners();
  }

  // Menu global
  void showTrashOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => AppBottomSheet(
        items: [
          BottomSheetItem(
            assetName: 'assets/icons/select.svg',
            label: 'Sélectionner',
            onTap: () {
              Navigator.pop(bottomSheetContext);
              _isSelectionMode = true;
              notifyListeners();
            },
            color: AppColors.foreground,
          ),
          BottomSheetItem(
            assetName: 'assets/icons/select_all.svg',
            label: 'Tout sélectionner',
            onTap: () {
              Navigator.pop(bottomSheetContext);
              _isSelectionMode = true;
              selectAll();
            },
            color: AppColors.foreground,
          ),
          BottomSheetItem(
            assetName: 'assets/icons/trash.svg',
            label: 'Vider la corbeille',
            onTap: () {
              Navigator.pop(bottomSheetContext);
              Future.delayed(Duration(milliseconds: 100), () {
                showEmptyTrashDialog(context);
              });
            },
            color: AppColors.destructive,
          ),
        ],
      ),
    );
  }

  // Menu d'options pour un fichier
  void showFileOptionsSheet(BuildContext context, String fileId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => AppBottomSheet(
        items: [
          BottomSheetItem(
            assetName: 'assets/icons/restore.svg',
            label: 'Restaurer',
            onTap: () {
              Navigator.pop(bottomSheetContext);
              Future.delayed(Duration(milliseconds: 100), () {
                _restoreFile(context, fileId);
              });
            },
            color: AppColors.foreground,
          ),
          BottomSheetItem(
            assetName: 'assets/icons/trash.svg',
            label: 'Supprimer définitivement',
            onTap: () {
              Navigator.pop(bottomSheetContext);
              Future.delayed(Duration(milliseconds: 100), () {
                _deleteFilePermanently(context, fileId);
              });
            },
            color: AppColors.destructive,
          ),
        ],
      ),
    );
  }

  void _restoreFile(BuildContext context, String fileId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Restaurer ce fichier ?',
        description: 'Le fichier sera restauré à son emplacement d\'origine.',
        cancelLabel: 'Annuler',
        confirmLabel: 'Restaurer',
        confirmBgColor: AppColors.primary,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (confirmed == true) {
      _trashedFiles.removeWhere((file) => file.id == fileId);
      notifyListeners();
      if (context.mounted) {
        showSuccessSnackbar(context, 'Fichier restauré avec succès');
      }
    }
  }

  void _deleteFilePermanently(BuildContext context, String fileId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Supprimer définitivement ?',
        description:
            'Cette action est irréversible. Le fichier sera supprimé de manière permanente.',
        cancelLabel: 'Annuler',
        confirmLabel: 'Supprimer',
        confirmBgColor: AppColors.destructive,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (confirmed == true) {
      _trashedFiles.removeWhere((file) => file.id == fileId);
      notifyListeners();
      if (context.mounted) {
        showSuccessSnackbar(context, 'Fichier supprimé définitivement');
      }
    }
  }

  // Actions multiples
  void restoreSelectedFiles(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Restaurer ${_selectedFileIds.length} fichier(s) ?',
        description:
            'Les fichiers seront restaurés à leur emplacement d\'origine.',
        cancelLabel: 'Annuler',
        confirmLabel: 'Restaurer',
        confirmBgColor: AppColors.primary,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (confirmed == true) {
      _trashedFiles.removeWhere((file) => _selectedFileIds.contains(file.id));
      exitSelectionMode();
      if (context.mounted) {
        showSuccessSnackbar(context, 'Fichiers restaurés avec succès');
      }
    }
  }

  void deleteSelectedFiles(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title:
            'Supprimer ${_selectedFileIds.length} fichier(s) définitivement ?',
        description: 'Cette action est irréversible.',
        cancelLabel: 'Annuler',
        confirmLabel: 'Supprimer',
        confirmBgColor: AppColors.destructive,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (confirmed == true) {
      _trashedFiles.removeWhere((file) => _selectedFileIds.contains(file.id));
      exitSelectionMode();
      if (context.mounted) {
        showSuccessSnackbar(context, 'Fichiers supprimés définitivement');
      }
    }
  }

  void showEmptyTrashDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Vider la corbeille ?',
        description:
            'Tous les fichiers de la corbeille seront supprimés définitivement. Cette action est irréversible.',
        cancelLabel: 'Annuler',
        confirmLabel: 'Vider',
        confirmBgColor: AppColors.destructive,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (confirmed == true) {
      _trashedFiles.clear();
      notifyListeners();
      if (context.mounted) {
        showSuccessSnackbar(context, 'Corbeille vidée');
      }
    }
  }
}
