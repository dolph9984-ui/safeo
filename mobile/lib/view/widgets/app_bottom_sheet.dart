import 'package:flutter/material.dart';
import 'package:securite_mobile/view/widgets/bottom_sheet_item.dart';

class AppBottomSheet extends StatelessWidget {
  final List<BottomSheetItem> items;
  final Function()? onClosing;

  const AppBottomSheet({super.key, required this.items, this.onClosing});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: onClosing ?? () {},
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: items,
        ),
      ),
    );
  }
}
