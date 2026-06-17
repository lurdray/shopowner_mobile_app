import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';

class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BorderRadius? radius;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const CustomImageView({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.fit,
    this.radius,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (imagePath == null) return _placeholder();

    final path = imagePath!;

    if (path.startsWith('http') || path.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: path,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        placeholder: (context, url) => _placeholder(),
        errorWidget: (context, url, error) => _placeholder(),
      );
    }

    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    }

    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      color: AppColors.secClr.withOpacity(.3),
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.primaryClr,
      ),
    );
  }
}
