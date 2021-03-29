import 'package:flutter/material.dart';
import 'package:easy_form_example/advanced_example/screens/custom_field/custom_field_screen.dart';
import 'package:easy_form_example/advanced_example/screens/login_demo/login_demo_screen.dart';
import 'package:easy_form_example/advanced_example/screens/save_indicator/save_indicator_screen.dart';
import 'package:easy_form_example/advanced_example/screens/save_error/save_error_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyForm Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 230,
              maxWidth: 600,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DemoButton(
                    text: 'Login form',
                    builder: (context) => LoginDemoScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Custom field',
                    builder: (context) => CustomFieldScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Save indicator',
                    builder: (context) => SaveIndicatorScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Save error',
                    builder: (context) => SaveErrorScreen(),
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

class _DemoButton extends StatelessWidget {
  final String text;
  final WidgetBuilder builder;

  const _DemoButton({
    Key? key,
    required this.text,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(text),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: builder,
        ),
      ),
    );
  }
}
