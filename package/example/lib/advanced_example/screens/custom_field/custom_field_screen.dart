import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:easy_form_example/advanced_example/screens/custom_field/widgets/color_form_field.dart';

class CustomFieldScreen extends StatelessWidget {
  final ValueNotifier<Color?> color = ValueNotifier(Colors.teal);

  CustomFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: EasyForm(
                onSave: (values, form) async {
                  return Future.delayed(
                      const Duration(seconds: 1), () => values['color']);
                },
                onSaved: (newColor, values, form) => color.value = newColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Color field
                    const Text('Press the circle to choose a random color'),
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
                            child: const Text('Back'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),

                    //
                    const Divider(),

                    // Color preview
                    const SizedBox(height: 24),
                    const Text('Color preview'),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: color,
                      builder: (context, Color? colorValue, child) => Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: colorValue,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: const [
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
      ),
    );
  }
}
