import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.borderSide,
    this.enabledBorderSide,
    this.onTapOutside,
    this.color,
    this.fillColor,
    this.radius,
    this.initialValue,
    this.contentPadding,
    this.hintStyle,
    this.isFilled,
    this.autofillHints,
    this.isHintFloating,
    this.onFieldSubmitted,
    this.fontStyle,
    this.readOnly = false,
    this.counterText,
    this.alignment,
    this.width,
    this.onTap,
    this.height,
    this.inputFormatters,
    this.margin,
    this.controller,
    this.focusNode,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.maxLength,
    this.hintText,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.autofocus = false,
    this.validator,
    this.onChanged,
  });

  final BorderSide? borderSide;
  final BorderSide? enabledBorderSide;
  final Function(PointerDownEvent)? onTapOutside;
  final Color? color;
  final Color? fillColor;
  final double? radius;
  final String? initialValue;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final bool? isFilled;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final bool? isHintFloating;
  final Function(String)? onFieldSubmitted;
  final TextStyle? fontStyle;
  final bool? readOnly;
  final Widget? counterText;
  final Alignment? alignment;
  final double? width;
  final Function()? onTap;
  final double? height;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? margin;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? isObscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  Widget _buildTextFormFieldWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: height ?? 0),
      width: width ?? 0,
      margin: margin,
      child: TextFormField(
        autofocus: autofocus,
        initialValue: initialValue,
        onFieldSubmitted: onFieldSubmitted,
        onTap: onTap,
        maxLength: maxLength,
        onTapOutside: onTapOutside,
        autofillHints: autofillHints,
        onChanged: onChanged,
        readOnly: readOnly!,
        controller: controller,
        focusNode: focusNode,
        style: hintStyle ?? _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
        inputFormatters: inputFormatters,
      ),
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      counter: counterText,
      hintText: isHintFloating != null ? '' : hintText ?? "",
      labelText: isHintFloating != null ? hintText : null,
      labelStyle: hintStyle ??
          const TextStyle(color: Colors.grey, fontSize: 13.0),
      floatingLabelStyle: isHintFloating != null
          ? const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.philosopher,
              fontSize: 15,
            )
          : null,
      hintStyle: hintStyle ??
          const TextStyle(
            color: Colors.black54,
            fontSize: 13.0,
            fontFamily: FontFamily.philosopher,
          ),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: _setOutlineBorderRadius(),
        borderSide: enabledBorderSide ??
            const BorderSide(color: AppColors.primaryClr),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: _setOutlineBorderRadius(),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _setOutlineBorderRadius(),
        borderSide: enabledBorderSide ??
            const BorderSide(color: AppColors.primaryClr),
      ),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      isCollapsed: false,
      errorStyle: const TextStyle(fontSize: 13),
      suffixIconConstraints: suffixConstraints,
      filled: isFilled ?? false,
      isDense: true,
      fillColor: fillColor,
      contentPadding: contentPadding,
    );
  }

  TextStyle _setFontStyle() {
    return const TextStyle(fontFamily: FontFamily.philosopher);
  }

  BorderRadius _setOutlineBorderRadius() {
    return BorderRadius.circular(radius ?? 0);
  }

  OutlineInputBorder _setBorderStyle() {
    return OutlineInputBorder(
      borderRadius: _setOutlineBorderRadius(),
      borderSide: borderSide ?? const BorderSide(color: Colors.black),
    );
  }
}
