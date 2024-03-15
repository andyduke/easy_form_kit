import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:easy_form_example/advanced_example/screens/logged/logged_screen.dart';

class FieldsErrorsScreen extends StatefulWidget {
  const FieldsErrorsScreen({super.key});

  @override
  FieldsErrorsScreenState createState() => FieldsErrorsScreenState();
}

class FieldsErrorsScreenState extends State<FieldsErrorsScreen> {
  Map<String, String>? errors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: EasyForm(
              // key: _formKey,
              errors: errors,
              onSave: (values, form) async {
                await Future.delayed(const Duration(seconds: 1));

                if (errors == null) {
                  setState(() {
                    errors = {
                      'username': 'Invalid username.',
                      'password': 'Password is too short.',
                    };
                  });
                  return false;
                } else {
                  setState(() {
                    errors = null;
                  });
                  return true;
                }

                /*
                _formKey.currentState?.setErrors({
                  'username': 'Invalid username.',
                  'password': 'Password is too short.',
                });
                return false;
                */

                /*
                form.setErrors({
                  'username': 'Invalid username.',
                  'password': 'Password is too short.',
                });
                return false;
                */
              },
              onSaved: (response, values, form) {
                if (response) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoggedScreen(),
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
                      if (value?.isEmpty ?? true) {
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
                        EasyFormSaveButton.text('Sign In'),
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
    );
  }
}
