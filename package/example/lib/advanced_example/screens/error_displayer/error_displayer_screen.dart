import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';

class ErrorDisplayerScreen extends StatelessWidget {
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
                  await Future.delayed(const Duration(seconds: 1));

                  form.setErrors({
                    'username': 'Username is too weak.',
                    'switch':
                        (values['switch'] == false) ? 'Invalid value.' : null,
                  });

                  return false;
                },
                onSaved: (response, values, form) {
                  if (response != false) {
                    _alert(context, 'Saved');
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    EasyCustomFormField<bool, EasyFormFieldController<bool>>(
                      name: 'switch',
                      initialValue: false,
                      controllerBuilder: (value) =>
                          EasyFormFieldController<bool>(value ?? false),
                      builder: (fieldState, onChangedHandler) => Switch(
                        value: fieldState.value,
                        onChanged: onChangedHandler,
                      ),
                    ),
                    EasyFormFieldError(
                      name: 'switch',
                      textStyle: TextStyle(color: Colors.red),
                    ),

                    //
                    EasyTextFormField(
                      name: 'username',
                      initialValue: 'John',
                      decoration: InputDecoration(
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
                      initialValue: 'qwerty',
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
      ),
    );
  }

  Future<void> _alert(BuildContext context, String text,
      {String? title}) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: (title != null) ? Text(title) : null,
        content: Text(text),
      ),
    );
  }
}
