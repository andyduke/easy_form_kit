import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:easy_form_example/advanced_example/screens/logged/logged_screen.dart';

class SaveErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: EasyForm(
              onSave: (values) async {
                await Future.delayed(const Duration(seconds: 1));
                throw UnimplementedError('Unimplemented');
              },
              onSaved: (response, values) {
                if (response['hasError']) {
                  _alert(context, response['error']);
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoggedScreen(),
                    ),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  EasyTextFormField(
                    name: 'username',
                    decoration: const InputDecoration(
                      hintText: 'Enter your username',
                    ),
                    validator: (value, [values]) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  EasyTextFormField(
                    name: 'password',
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                    ),
                    obscureText: true,
                    validator: (value, [values]) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      children: [
                        EasyFormSaveButton.text('Sign In'),
                        const SizedBox(width: 24),
                        TextButton(
                          child: Text('Back'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
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
