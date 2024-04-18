import 'package:flutter/material.dart';

Color _customColor = Color(int.parse('0xFF7531FF'));

List<Color> _colorThemes = [
  _customColor,
  Color(int.parse('0xFF3C3C3C')),
  Color(int.parse('0xFFFFFFFF')),
  Color(int.parse('0xFFA7A7A7')),
  Color(int.parse('0xFF2B90F5')),
  Color(int.parse('0xFF000000')),
  Color(int.parse('0xFFA5F52B')),
  Color(int.parse('0xFF2BF59D')),
];

class AppTheme {
  final int selectedColor;

  AppTheme({required this.selectedColor})
      : assert(selectedColor >= 0 && selectedColor <= _colorThemes.length - 1,
            'Colors must be between 0 and ${_colorThemes.length}');

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
    );
  }

  
}
