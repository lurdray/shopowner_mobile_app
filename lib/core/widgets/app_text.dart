import 'package:flutter/material.dart';
import 'package:shopowner_mobile_app/core/app_const.dart';
import 'package:substring_highlight/substring_highlight.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontWeight? highLightWeight;
  final Color? fontClr;
  final Color? txtHighlightClr;
  final String? fontFamily;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final bool shouldHighlight;
  final List<String> wordHighlight;
  final double? decorationThickness;
  final double? textHeight;
  final TextDecoration? decoration;
  final List<Shadow>? shadows;

  const AppText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.highLightWeight,
    this.fontClr = Colors.black,
    this.txtHighlightClr,
    this.fontFamily,
    this.maxLines,
    this.textAlign,
    this.textOverflow,
    this.fontStyle,
    this.shouldHighlight = false,
    this.wordHighlight = const [],
    this.decorationThickness,
    this.textHeight,
    this.decoration,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return SubstringHighlight(
      maxLines: maxLines ?? 3,
      textAlign: textAlign ?? TextAlign.left,
      overflow: TextOverflow.ellipsis,
      text: text,
      terms: wordHighlight,
      textStyleHighlight: TextStyle(
        fontSize: fontSize,
        height: textHeight,
        fontWeight: highLightWeight ?? fontWeight,
        color: txtHighlightClr,
        fontFamily: fontFamily ?? generalFontFam,
      ),
      textStyle: TextStyle(
        decoration: decoration,
        shadows: shadows,
        fontSize: fontSize,
        height: textHeight,
        fontWeight: fontWeight,
        color: fontClr,
        fontFamily: fontFamily ?? generalFontFam,
        overflow: textOverflow,
        decorationThickness: decorationThickness,
        decorationColor: fontClr,
        fontStyle: fontStyle,
      ),
    );
  }
}
