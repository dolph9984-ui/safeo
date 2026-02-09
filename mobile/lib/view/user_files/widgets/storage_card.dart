import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/utils/file_size_util.dart';

class StorageCard extends StatelessWidget {
  final int used;
  final int totalStorage;

  const StorageCard({
    super.key,
    required this.used,
    required this.totalStorage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/shadows/ellipse_1.png'),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/shadows/ellipse_2.png'),
          ),

          Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/storage.svg',
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      height: 24,
                      width: 24,
                    ),
                    Text(
                      'Mon stockage',
                      style: TextStyle(
                        fontFamily: AppFonts.zalandoSans,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      totalStorage >= 1024 * 1024 * 1024
                          ? '${FileSizeUtil.bytesToGb(used)}GB'
                          : '${FileSizeUtil.bytesToMb(used)}MB',

                      style: TextStyle(
                        fontFamily: AppFonts.productSansMedium,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      totalStorage >= 1024 * 1024 * 1024
                          ? ' / ${FileSizeUtil.bytesToGb(totalStorage)}GB'
                          : ' / ${FileSizeUtil.bytesToMb(totalStorage)}MB',

                      style: TextStyle(
                        fontFamily: AppFonts.productSansRegular,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),
                spaceIndicator(used, totalStorage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget spaceIndicator(int used, int total) {
    double ratio = (used / total).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          clipBehavior: Clip.hardEdge,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppColors.blue400,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: constraints.maxWidth * ratio,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
