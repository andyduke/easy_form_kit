import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:easy_form_example/advanced_example/screens/custom_field/widgets/color_controller.dart';
import 'package:easy_form_example/advanced_example/screens/custom_field/widgets/color_field.dart';

class ColorFormField extends EasyCustomFormField<Color?, ColorController> {
  ColorFormField({
    super.key,
    required super.name,
    super.controller,
    Color? initialValue,
  }) : super(
          initialValue: initialValue ?? const Color(0x00000000),
          controllerBuilder: (value) => ColorController(value),
          builder: (state, onChangedHandler) {
            return ColorField(
              controller: state.controller as ColorController,
              onChange: onChangedHandler,
            );
          },
        );
}
