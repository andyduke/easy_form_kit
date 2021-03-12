import 'dart:math';
import 'package:easy_form_example/screens/custom_field/widgets/color_controller.dart';
import 'package:easy_form_kit/easy_form.dart';
import 'package:flutter/material.dart';

class ColorField extends EasyFormGenericField<Color> {
  ColorField({
    Key key,
    @required ColorController controller,
    ValueChanged<Color> onChange,
  }) : super(
          key: key,
          controller: controller,
          onChange: onChange,
        );

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
