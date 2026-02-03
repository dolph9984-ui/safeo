import 'package:flutter/material.dart';

class AuthScrollableBody extends StatelessWidget {
  final List<Widget> children;

  const AuthScrollableBody({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 64),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}
