import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:flutter/material.dart';

class SaveIndicatorScreen extends StatelessWidget {
  const SaveIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: EasyForm(
              onSave: (values, form) async {
                return Future.delayed(const Duration(seconds: 3), () => true);
              },
              onSaved: (response, values, form) {
                _alert(context, 'Saved');
              },
              child: EasyFormSaveIndicator(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    EasyTextFormField(
                      name: 'username',
                      initialValue: 'John',
                      decoration: const InputDecoration(
                        hintText: 'Enter your username',
                      ),
                      validator: (value, [values]) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    EasyTextFormField(
                      name: 'password',
                      initialValue: '123456',
                      decoration: const InputDecoration(
                        hintText: 'Enter your password',
                      ),
                      obscureText: true,
                      validator: (value, [values]) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Row(
                        children: [
                          EasyFormButton(
                            builder: (context, form) => OutlinedButton(
                              child: const Text('Sign In'),
                              onPressed: () => form?.save(),
                            ),
                          ),
                          const SizedBox(width: 24),
                          TextButton(
                            child: const Text('Back'),
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
      ),
    );
  }

  Future<void> _alert(BuildContext context, String text) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
