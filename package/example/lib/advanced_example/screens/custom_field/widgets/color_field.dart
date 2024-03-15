import 'dart:math';
import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:easy_form_example/advanced_example/screens/custom_field/widgets/color_controller.dart';

class ColorField extends EasyFormGenericField<Color> {
  const ColorField({
    super.key,
    required ColorController super.controller,
    super.onChange,
  });

  void _change() {
    value = _getRandomColor();
  }

  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: _change,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: value,
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
