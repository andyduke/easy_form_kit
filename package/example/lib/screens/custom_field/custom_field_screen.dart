import 'package:easy_form_example/screens/custom_field/widgets/color_form_field.dart';
import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:flutter/material.dart';

class CustomFieldScreen extends StatelessWidget {
  final ValueNotifier<Color> color = ValueNotifier(Colors.teal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: EasyForm(
              onSave: (values) async {
                return Future.delayed(
                    const Duration(seconds: 1), () => values['color']);
              },
              onSaved: (newColor, values) => color.value = newColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Color field
                  Text('Press the circle to choose a random color'),
                  const SizedBox(height: 16),
                  ColorFormField(
                    name: 'color',
                    initialValue: color.value,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      children: [
                        EasyFormSaveButton.text('Preview'),
                        const SizedBox(width: 24),
                        TextButton(
                          child: Text('Back'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                  //
                  const Divider(),

                  // Color preview
                  const SizedBox(height: 24),
                  Text('Color preview'),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                    valueListenable: color,
                    builder: (context, colorValue, child) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colorValue,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
