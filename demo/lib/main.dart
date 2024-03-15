import 'package:demo/screens/custom_field/custom_field_screen.dart';
import 'package:demo/screens/login_demo/login_demo_screen.dart';
import 'package:demo/screens/save_indicator/save_indicator_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyForm Demo',
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
              ],
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
