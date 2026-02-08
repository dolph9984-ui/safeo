import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class SharedFileSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String iconPath;
  final ValueChanged<String>? onChanged;
  final bool autoFocus; 

  const SharedFileSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconPath,
    this.onChanged,
    this.autoFocus = false, 
  });

  @override
  State<SharedFileSearchBar> createState() => _SharedFileSearchBarState();
}

class _SharedFileSearchBarState extends State<SharedFileSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.foreground.withAlpha(10),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autoFocus, 
        onChanged: widget.onChanged,
        style: TextStyle(
          fontSize: 14,
          fontFamily: AppFonts.productSansMedium,
          color: AppColors.foreground,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.productSansMedium,
            color: AppColors.mutedForeground,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              widget.iconPath,
              colorFilter: ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? InkWell(
                  onTap: () {
                    widget.controller.clear();
                    widget.onChanged?.call('');
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/icons/x.svg',
                      colorFilter: ColorFilter.mode(
                        AppColors.mutedForeground,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}