import 'package:flutter/material.dart';

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> adele = [
    Color(0xFF009ffd),
    Color(0xFF2a2a72)
  ]; //very good shade
  // static List<Color> cheapCocktail = [Color(0xFF37d5d6), Color(0xFF36096d)]; //good shade
  // static List<Color> sea = [Color(0xFF09c6f9), Color(0xFF045de9)];
  // static List<Color> lightblue1 = [Color(0xFF2c69d1), Color(0xFF0abcf9)];
  // static List<Color> lightblue = [Color(0xFF08c8f6), Color(0xFF4d5dfb)];
  // static List<Color> bird = [Color(0xFF087ee1), Color(0xFF05e8ba)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.adele),
    // GradientColors(GradientColors.cheapCocktail),
    // GradientColors(GradientColors.sea),
    // GradientColors(GradientColors.lightblue1),
    // GradientColors(GradientColors.lightblue),
    // GradientColors(GradientColors.bird),
  ];
}

class Colorscheck {
  static List checkColors = [
    Colors.blue.shade900,
    Colors.blue.shade500,
    Colors.blue.shade800,
    Colors.blue.shade700,
  ];
}

final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);
