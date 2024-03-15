import 'package:easy_form_example/advanced_example/screens/fields_errors/fields_errors_screen.dart';
import 'package:easy_form_example/advanced_example/screens/global_settings_demo/gloabal_settings_demo_screen.dart';
import 'package:easy_form_example/advanced_example/screens/typed_result/typed_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_form_example/advanced_example/screens/custom_field/custom_field_screen.dart';
import 'package:easy_form_example/advanced_example/screens/login_demo/login_demo_screen.dart';
import 'package:easy_form_example/advanced_example/screens/save_indicator/save_indicator_screen.dart';
import 'package:easy_form_example/advanced_example/screens/save_error/save_error_screen.dart';
import 'package:easy_form_example/advanced_example/screens/clear_value/clear_value_screen.dart';
import 'package:easy_form_example/advanced_example/screens/error_displayer/error_displayer_screen.dart';

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
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
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
                    builder: (context) => const LoginDemoScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Custom field',
                    builder: (context) => CustomFieldScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Save indicator',
                    builder: (context) => const SaveIndicatorScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Save error',
                    builder: (context) => const SaveErrorScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Fields errors',
                    builder: (context) => const FieldsErrorsScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Clear value',
                    builder: (context) => ClearValueScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Error displayer',
                    builder: (context) => const ErrorDisplayerScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Typed form',
                    builder: (context) => const TypedResultDemoScreen(),
                  ),
                  const SizedBox(height: 16),
                  _DemoButton(
                    text: 'Global Settings Demo',
                    builder: (context) => const GlobalSettingsDemoScreen(),
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
    required this.text,
    required this.builder,
  });

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
