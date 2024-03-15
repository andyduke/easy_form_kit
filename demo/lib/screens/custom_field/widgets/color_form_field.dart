import 'package:demo/screens/custom_field/widgets/color_controller.dart';
import 'package:demo/screens/custom_field/widgets/color_field.dart';
import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:flutter/material.dart';

class ColorFormField extends EasyCustomFormField<Color, ColorController> {
  ColorFormField({
    Key? key,
    required String name,
    ColorController? controller,
    Color? initialValue,
  }) : super(
          key: key,
          name: name,
          controller: controller,
          initialValue: initialValue ?? Color(0x00000000),
          controllerBuilder: (value) => ColorController(value ?? Colors.transparent),
          builder: (state, onChangedHandler) {
            return ColorField(
              controller: state.controller as ColorController,
              onChange: (color) => onChangedHandler(color ?? Colors.transparent),
            );
          },
        );
}
