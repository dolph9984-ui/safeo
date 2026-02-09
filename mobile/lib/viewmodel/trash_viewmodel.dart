import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/enum/file_filter_enum.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/utils/file_name_util.dart';
import 'package:securite_mobile/view/widgets/app_bottom_sheet.dart';
import 'package:securite_mobile/view/widgets/bottom_sheet_item.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';
import 'package:securite_mobile/view/widgets/success_snackbar.dart';

class TrashViewModel extends ChangeNotifier {
  final DocumentModel documentModel;
  final UserModel userModel;
  final SessionModel sessionModel;

  User? _user;
  List<Document>? _trashFiles;
  List<Document>? _filteredFiles;
  Set<String> _selectedFileIds = {};
  bool _isSelectionMode = false;

  FileFilterEnum _currentFilter = FileFilterEnum.all;

  FileFilterEnum get currentFilter => _currentFilter;

  List<Document> get trashedFiles => _filteredFiles ?? [];

  Set<String> get selectedFileIds => _selectedFileIds;

  bool get isSelectionMode => _isSelectionMode;

  User? get currentUser => _user;

  bool get hasFiles => (_filteredFiles ?? []).isNotEmpty;

  int get filesCount => (_filteredFiles ?? []).length;

  TrashViewModel({
    DocumentModel? fileModel,
    UserModel? userModel,
    SessionModel? sessionModel,
  }) : documentModel = fileModel ?? DocumentModel(),
       userModel = userModel ?? UserModel(),
       sessionModel = sessionModel ?? SessionModel();

  void initUser() {
    if (sessionModel.session == null) {
      sessionModel.destroySession();
      _user = User.none();
      return;
    }
    _user = sessionModel.session!.user;
    notifyListeners();
  }

  void initFiles() {
    documentModel.getTrashFiles().then((res) {
      _trashFiles = res;
      _filteredFiles = res;
      notifyListeners();
    });
  }

  void setCurrentFilter(FileFilterEnum newFilter) {
    _currentFilter = newFilter;
    _filterFiles();
    notifyListeners();
  }

  void _filterFiles() {
    const filterMap = {
      FileFilterEnum.pdf: FileTypeEnum.pdf,
      FileFilterEnum.image: FileTypeEnum.image,
      FileFilterEnum.document: FileTypeEnum.document,
      FileFilterEnum.csv: FileTypeEnum.csv,
    };

    final targetType = filterMap[_currentFilter];

    _filteredFiles = targetType == null
        ? _trashFiles
        : _trashFiles
              ?.where(
                (file) =>
                    FileTypeEnum.fromExtension(
                      FileNameUtil.getExtension(file.originalName),
                    ) ==
                    targetType,
              )
              .toList();
  }

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
    _selectedFileIds = (_filteredFiles ?? []).map((f) => f.id).toSet();
    notifyListeners();
  }

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
    final file = _trashFiles?.firstWhere((f) => f.id == fileId);
    if (file == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
      builder: (context) => ConfirmDialog(
        title: 'Restaurer ce fichier ?',
        description:
            'Le fichier "${file.originalName}" sera restauré à son emplacement d\'origine.',
        cancelLabel: 'Annuler',
        confirmLabel: 'Restaurer',
        confirmBgColor: AppColors.primary,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (confirmed == true) {
      await documentModel.restoreFile(file);

      _trashFiles?.removeWhere((f) => f.id == fileId);
      _filterFiles();
      notifyListeners();

      if (context.mounted) {
        showSuccessSnackbar(context, 'Fichier restauré avec succès');
      }
    }
  }

  void _deleteFilePermanently(BuildContext context, String fileId) async {
    final file = _trashFiles?.firstWhere((f) => f.id == fileId);
    if (file == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
      builder: (context) => ConfirmDialog(
        title: 'Supprimer définitivement ?',
        description:
            'Le fichier "${file.originalName}" sera supprimé de manière permanente. Cette action est irréversible.',
        cancelLabel: 'Annuler',
        confirmLabel: 'Supprimer',
        confirmBgColor: AppColors.destructive,
        onConfirm: () {},
        onCancel: () {},
      ),
    );

    if (confirmed == true) {
      await documentModel.deleteFilePermanently(file);

      _trashFiles?.removeWhere((f) => f.id == fileId);
      _filterFiles();
      notifyListeners();

      if (context.mounted) {
        showSuccessSnackbar(context, 'Fichier supprimé définitivement');
      }
    }
  }

  void restoreSelectedFiles(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
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
      await documentModel.restoreFiles(_selectedFileIds.toList());

      _trashFiles?.removeWhere((file) => _selectedFileIds.contains(file.id));
      _filterFiles();
      exitSelectionMode();

      if (context.mounted) {
        showSuccessSnackbar(context, 'Fichiers restaurés avec succès');
      }
    }
  }

  void deleteSelectedFiles(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
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
      await documentModel.deleteFilesPermanently(_selectedFileIds.toList());

      _trashFiles?.removeWhere((file) => _selectedFileIds.contains(file.id));
      _filterFiles();
      exitSelectionMode();

      if (context.mounted) {
        showSuccessSnackbar(context, 'Fichiers supprimés définitivement');
      }
    }
  }

  void showEmptyTrashDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
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
      await documentModel.emptyTrash();

      _trashFiles?.clear();
      _filterFiles();
      notifyListeners();

      if (context.mounted) {
        showSuccessSnackbar(context, 'Corbeille vidée');
      }
    }
  }
}
