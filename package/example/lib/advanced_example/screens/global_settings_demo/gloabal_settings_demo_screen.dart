import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';
import 'package:easy_form_example/advanced_example/screens/logged/logged_screen.dart';

class GlobalSettingsDemoScreen extends StatelessWidget {
  const GlobalSettingsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyFormDefaultSettings(
      actionButton: EasyFormActionButtonSettings(
        builder: (context, key, child, onPressed, adaptivity) =>
            OutlinedButton(onPressed: onPressed, child: child),
      ),
      saveButton: EasyFormSaveButtonSettings(
        builder: (context, key, child, onPressed, adaptivity) => ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.amber.shade700),
          onPressed: onPressed,
          child: child,
        ),
        indicatorBuilder: (context, size, adaptivity) => const Center(
          child: SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.5,
            ),
          ),
        ),
        layoutBuilder: (context, body, indicator) => Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            body,
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: indicator,
            ),
          ],
        ),
      ),
      resetButton: EasyFormResetButtonSettings(
        builder: (context, key, child, onPressed, adaptivity) =>
            IconButton.filledTonal(
          onPressed: onPressed,
          icon: const Icon(Icons.clear),
          tooltip: 'Clear form',
        ),
      ),
      saveIndicator: EasyFormSaveIndicatorSettings(
        builder: (context, size, adaptivity) => const Center(
          child: SizedBox.square(
            dimension: 56,
            child: CircularProgressIndicator(
              color: Colors.amber,
              strokeWidth: 2,
            ),
          ),
        ),
        layoutBuilder: (context, body, [indicator]) => Stack(
          children: [
            body,
            if (indicator != null)
              Positioned(
                top: 0,
                right: 0,
                child: indicator,
              ),
          ],
        ),
      ),
      error: EasyFormFieldErrorSettings(
        builder: (context, fieldName, errorText) {
          final hasError = errorText?.isNotEmpty ?? false;
          return hasError
              ? Text(errorText!,
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.red))
              : const SizedBox();
        },
      ),

      //
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: EasyForm(
                onSave: (values, form) async {
                  return Future.delayed(const Duration(seconds: 3), () {
                    return <String, dynamic>{
                      'hasError': true,
                      'error': {
                        'username': 'Invalid username.',
                      },
                    };
                  });
                },
                onSaved: (response, values, form) {
                  if (response['hasError']) {
                    if (response['error'] is! Map) {
                      _alert(context, response['error'] ?? 'Unknown error');
                    } else {
                      form.setErrors(response['error']);
                    }
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoggedScreen(),
                      ),
                    );
                  }
                },
                child: EasyFormSaveIndicator(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const EasyFormFieldError(name: 'username'),

                      //
                      EasyTextFormField(
                        name: 'username',
                        saveOnSubmit: true,
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
                        saveOnSubmit: true,
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
                            EasyFormResetButton.text('Clear form'),
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
