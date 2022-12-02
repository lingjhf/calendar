import 'package:flutter/material.dart';

class CalendarStyle extends ThemeExtension<CalendarStyle> {
  CalendarStyle({
    Color? backgroundColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    Color? accentBackgroundColor,
  })  : backgroundColor = backgroundColor ?? const Color(0xffffffff),
        padding = padding ?? const EdgeInsets.all(16),
        borderRadius = borderRadius ?? BorderRadius.circular(16),
        primaryColor = primaryColor ?? const Color(0xff000000),
        secondaryColor =
            secondaryColor ?? const Color(0xff3C3C43).withOpacity(0.3),
        accentColor = accentColor ?? const Color(0xff0084FF),
        accentBackgroundColor =
            accentBackgroundColor ?? const Color(0xff0084FF).withOpacity(0.3);

  //背景颜色
  final Color backgroundColor;

  //内间距
  final EdgeInsets padding;

  //圆角
  final BorderRadius borderRadius;

  final Color primaryColor;

  final Color secondaryColor;

  final Color accentColor;

  final Color accentBackgroundColor;

  //暗黑风格
  factory CalendarStyle.dark() => CalendarStyle(
      backgroundColor: const Color(0xff000000),
      primaryColor: const Color(0xffffffff),
      secondaryColor: const Color(0xffEBEBF5).withOpacity(0.3));

  @override
  CalendarStyle copyWith({
    Color? backgroundColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    Color? accentBackgroundColor,
  }) {
    return CalendarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      accentBackgroundColor:
          accentBackgroundColor ?? this.accentBackgroundColor,
    );
  }

  @override
  CalendarStyle lerp(ThemeExtension<CalendarStyle>? other, double t) {
    if (other is! CalendarStyle) return this;
    return CalendarStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t),
      accentColor: Color.lerp(accentColor, other.accentColor, t),
      accentBackgroundColor:
          Color.lerp(accentBackgroundColor, other.accentBackgroundColor, t),
    );
  }
}
