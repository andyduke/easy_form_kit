import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';

extension StringNullEmptyChecks on String? {
  bool get isNullOrEmpty => (this == null) ? true : (this?.isEmpty ?? true);

  bool get isNotNullOrEmpty =>
      (this == null) ? false : (this?.isNotEmpty ?? false);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyForm Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

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
                  _alert(context, response['error'] ?? 'Unknown error');
                } else {
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
                      if (value.isNullOrEmpty) {
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
                      if (value.isNullOrEmpty) {
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
        title: const Text('Error'),
        content: Text(text),
      ),
    );
  }
}

class LoggedScreen extends StatelessWidget {
  const LoggedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Welcome, John.'),
              const SizedBox(height: 24),
              TextButton(
                child: const Text('Back'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
