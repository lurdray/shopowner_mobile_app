import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';

Widget loadingCircle([double size = 40, Color? color]) {
  return Center(
    child: LoadingAnimationWidget.threeArchedCircle(
      color: color ?? AppColors.primaryClr,
      size: size,
    ),
  );
}
