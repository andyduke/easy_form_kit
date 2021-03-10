import 'dart:math';
import 'package:easy_form_kit/easy_form.dart';
import 'package:flutter/material.dart';

/*
class ValueFieldController<T> extends ValueNotifier<T> {
  T _value;

  ValueFieldController(T value)
      : _value = value,
        super(value);

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}

class ColorField extends StatefulWidget {
  final ValueFieldController<Color> controller;
  final ValueChanged<Color> onChange;

  const ColorField({
    Key key,
    @required this.controller,
    this.onChange,
  })  : assert(controller != null),
        super(key: key);

  @override
  _ColorFieldState createState() => _ColorFieldState();
}

class _ColorFieldState extends State<ColorField> {
  @override
  void initState() {
    widget.controller.addListener(_update);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ColorField oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_update);
      widget.controller.addListener(_update);
    }

    super.didUpdateWidget(oldWidget);
  }

  void _update() {
    setState(() {});
  }

  void _change() {
    widget.controller.value = _getRandomColor();
    debugPrint('new value: ${widget.controller.value}');

    widget.onChange?.call(widget.controller.value);
  }

  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: _change,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: widget.controller.value,
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
*/

class ColorController extends EasyFormFieldController<Color> {
  ColorController(Color value) : super(value);
}

class ColorField extends EasyFormGenericField<Color> {
  ColorField({
    Key key,
    @required ColorController controller,
    ValueChanged<Color> onChange,
  }) : super(
          key: key,
          controller: controller,
          onChange: onChange,
        );

  void _change() {
    value = _getRandomColor();
  }

  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: _change,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: value,
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ---

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
        // visualDensity: VisualDensity.comfortable,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FormExampleScreen(),
    );
  }
}

class FormExampleScreen extends StatelessWidget {
  final _formKey = GlobalKey<EasyFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 56),
        child: EasyForm(
          key: _formKey,
          // saveButton: EasyFormSaveButton.text('Save'),
          // saveButton: EasyFormButton(child: Text('Save')),
          // saveButton: EasyFormSaveButton(child: Text('Save')),
          // saveButtonText: Text('Save'),
          onSave: (values) async {
            // debugPrint('${_formKey.currentState.fields}');
            debugPrint('Save: $values');

            await Future.delayed(const Duration(seconds: 2));

            /*
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Form data'),
                content: Text('$values'),
                actions: [
                  OutlinedButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
            */

            return true;
          },
          onSaved: (values) {
            debugPrint('Saved: $values');
          },
          child: Column(
            children: [
              /*
              EasyFormField<String>(
                name: 'name',
                initialValue: 'Text',
                builder: (field) => TextField(
                  controller: TextEditingController(text: field.value),
                  //
                ),
              ),
              */
              EasyTextFormField(
                name: 'name',
                initialValue: 'Text',
                validator: (value) => value.isEmpty ? 'Field is required.' : null,
              ),

              // Sep
              const SizedBox(height: 24),

              EasyCustomFormField<String, TextEditingController>(
                name: 'custom',
                initialValue: 'some text',
                controllerBuilder: (value) => TextEditingController(text: value),
                controllerRebuilder: (oldController) => TextEditingController.fromValue(oldController.value),
                valueGet: (controller) => controller.text,
                valueSet: (controller, newText) => controller.text = newText,
                builder: (fieldState, onChangedHandler) => TextField(
                  controller: fieldState.controller,
                  focusNode: fieldState.focusNode,
                  decoration: InputDecoration(
                    errorText: fieldState.errorText,
                  ),
                  onChanged: onChangedHandler,
                ),
                validator: (value) => value.isEmpty ? 'Field is required.' : null,
              ),

              // Sep
              const SizedBox(height: 24),

              EasyCustomFormField<Color, ColorController>(
                name: 'color',
                initialValue: Colors.teal,
                controllerBuilder: (value) => ColorController(value),
                builder: (fieldState, onChangedHandler) => ColorField(
                  controller: fieldState.controller,
                  onChange: onChangedHandler,
                ),
              ),

              // Sep
              const SizedBox(height: 24),

              ButtonBar(
                alignment: MainAxisAlignment.start,
                buttonPadding: EdgeInsets.zero,
                children: [
                  // EasyFormSaveButton.text('Save form'),
                  EasyFormSaveButton.text(
                    'Save',
                    // indicatorBuilder: (context, size) => CupertinoActivityIndicator(),
                  ),
                  const SizedBox(width: 16),
                  EasyFormResetButton.text('Reset'),
                  const SizedBox(width: 16),
                  EasyFormButton(
                    builder: (context, form) => OutlinedButton(
                      child: Text('Validate'),
                      onPressed: () => form.validate(),
                    ),
                  ),
                  // OutlinedButton(
                  //   child: Text('Reset form'),
                  //   onPressed: () {
                  //     _formKey.currentState.reset();
                  //   },
                  // ),
                ],
              ),
              const Divider(),

              Row(
                children: [
                  OutlinedButton(
                    child: Text('Save'),
                    onPressed: () {
                      _formKey.currentState.save();
                    },
                  ),

                  // Sep
                  const SizedBox(width: 24),

                  OutlinedButton(
                    child: Text('Reset'),
                    onPressed: () {
                      _formKey.currentState.reset();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
