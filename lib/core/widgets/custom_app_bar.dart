import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final double height;
  final ShapeBorder? shape;
  final double? leadingWidth;
  final bool forceMaterialTransparency;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.centerTitle = false,
    this.leading,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.height = kToolbarHeight,
    this.shape,
    this.leadingWidth,
    this.forceMaterialTransparency = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: shape,
      clipBehavior: Clip.none,
      forceMaterialTransparency: forceMaterialTransparency,
      title: title,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      actions: actions,
      leadingWidth: leadingWidth,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
