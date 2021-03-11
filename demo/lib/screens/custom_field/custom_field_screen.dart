import 'package:demo/screens/custom_field/widgets/color_form_field.dart';
import 'package:easy_form_kit/easy_form.dart';
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
                return Future.delayed(const Duration(seconds: 2), () => values['color']);
              },
              onSaved: (newColor) => color.value = newColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ColorFormField(
                    name: 'color',
                    initialValue: color.value,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: EasyFormSaveButton.text('Save'),
                  ),
                  const Divider(),
                  ValueListenableBuilder(
                    valueListenable: color,
                    builder: (context, colorValue, child) => Container(
                      margin: const EdgeInsets.only(top: 24),
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

  Future<void> _alert(BuildContext context, String text) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(text),
      ),
    );
  }
}
