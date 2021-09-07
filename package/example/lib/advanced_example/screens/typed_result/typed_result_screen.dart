import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';

class UserInfo {
  final String firstName;
  final String lastName;

  String get name => '$firstName $lastName';

  UserInfo({
    required this.firstName,
    required this.lastName,
  });
}

class TypedResultDemoScreen extends StatelessWidget {
  Future<UserInfo?> _save(
      BuildContext context, Map<String, dynamic> values, formState) async {
    return Future.delayed(const Duration(seconds: 3), () {
      final bool randomValue =
          math.Random(DateTime.now().millisecondsSinceEpoch).nextBool();

      if (!randomValue) {
        _alert(context, 'Save error');
        return null;
      } else {
        return UserInfo(
          firstName: values['first_name'],
          lastName: values['last_name'],
        );
      }
    });
  }

  void _saved(BuildContext context, UserInfo? user,
      Map<String, dynamic> fieldValues, formState) {
    if (user != null) {
      _alert(context, '${user.name}', title: 'Saved');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: EasyDataForm<UserInfo?>(
              onSave: (values, form) => _save(context, values, form),
              onSaved: (user, values, form) =>
                  _saved(context, user, values, form),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  EasyTextFormField(
                    name: 'first_name',
                    saveOnSubmit: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your first name',
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
                    name: 'last_name',
                    saveOnSubmit: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your last name',
                    ),
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
                        EasyFormSaveButton.text('Save'),
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

  Future<void> _alert(BuildContext context, String text,
      {String title = 'Error'}) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
