import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class RenameFileDialog extends StatefulWidget {
  final String initialName;
  final Function() onCancelPress;
  final Function(String newName) onConfirmPress;
  final FormFieldValidator<String> validator;

  const RenameFileDialog({
    super.key,
    required this.initialName,
    required this.onCancelPress,
    required this.onConfirmPress,
    required this.validator,
  });

  @override
  State<RenameFileDialog> createState() => _RenameFileDialogState();
}

class _RenameFileDialogState extends State<RenameFileDialog> {
  late final TextEditingController nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Text(
              'Renommer le fichier',
              style: TextStyle(
                color: AppColors.foreground,
                fontSize: 16,
                fontFamily: AppFonts.productSansMedium,
              ),
            ),
            TextFormField(
              controller: nameController,
              validator: widget.validator,
            ),
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancelPress,
                    child: Text('Annuler'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(40, 40)),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      widget.onConfirmPress(nameController.text);
                    },
                    child: Text('Confirmer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
