import 'package:demo/screens/logged/logged_screen.dart';
import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:flutter/material.dart';

class LoginDemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: EasyForm(
              onSave: (values, form) async {
                return Future.delayed(const Duration(seconds: 3), () {
                  return <String, dynamic>{
                    'hasError': false,
                  };
                });
              },
              onSaved: (response, values, form) {
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
                      if (value?.isEmpty ?? false) {
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
                      if (value?.isEmpty ?? false) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: EasyFormSaveButton.text('Sign In'),
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
