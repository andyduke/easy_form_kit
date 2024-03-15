import 'package:flutter/material.dart';
import 'package:easy_form_kit/easy_form_kit.dart';

class ErrorDisplayerScreen extends StatelessWidget {
  const ErrorDisplayerScreen({super.key});

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
                    const EasyFormFieldError(
                      name: 'switch',
                      textStyle: TextStyle(color: Colors.red),
                    ),

                    //
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

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Sed dapibus, ante ultricies adipiscing pulvinar, enim tellus volutpat odio, vel pretium ligula purus vel ligula. In posuere justo eget libero. Cras consequat quam sit amet metus. Sed vitae nulla. Cras imperdiet sapien vitae ipsum. Curabitur tristique. Aliquam non tellus eget sem commodo tincidunt. Phasellus cursus nunc. Integer vel mi. Aenean rutrum libero sit amet enim. Nunc elementum, erat eu volutpat ultricies, eros justo scelerisque leo, quis sollicitudin purus ipsum at purus. Aenean ut nulla.\n\n'
                        'Donec sit amet nisl in elit consequat vehicula. Ut leo ligula, lacinia vitae, tempor vel, eleifend vitae, odio. Cras aliquet dolor a justo. Ut molestie ornare sem. Sed est augue, euismod sed, ultrices suscipit, commodo a, nibh. Sed non sem vel mi pretium adipiscing. Nam nec sem. Quisque vel eros euismod odio convallis tincidunt. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Integer a est ut turpis adipiscing eleifend. Cras feugiat mollis metus. Nulla facilisi. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vitae leo. In a tortor. Nunc odio. Etiam hendrerit diam at diam. Nullam ac diam nec neque fringilla faucibus.',
                      ),
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
