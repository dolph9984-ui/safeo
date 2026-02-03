import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final Widget? suffixIcon;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.errorText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
