import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
import 'package:smart_snackbars/smart_snackbars.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class AppSnackBar {
  static showAnimatedSnackBar({
    required String message,
    required BuildContext context,
  }) {
    return SmartSnackBars.showCustomSnackBar(
      context: context,
      duration: const Duration(milliseconds: 4000),
      animateFrom: AnimateFrom.fromBottom,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: const Color(0xFFA7A7A7),
          borderRadius: BorderRadius.circular(8.r,),
        ),
        padding: EdgeInsets.only(
          left: 17.w,
          right: 8.w,
        ),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message,
                  style: AppFonts.bodyFont(
                    color: AppColors.secondaryColor,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.error_outline,
              )
            ),
          ],
        ),
      ),
    );
  }
}
