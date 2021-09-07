# EasyForm

A set of widgets for processing form field data in one common handler. Convenient for saving data to a database, sending via API, etc.

`EasyForm` and `EasyTextFormField` widgets are similar to and closely compatible with Flutter's `Form` and `TextFormField` widgets.

Form field widgets are placed in an `EasyForm` container, each field has a name (specified in the `name` parameter), when saved, the form field data is passed to the `onSave` callback as a `Map<String, dynamic>`, where the *key* is the field name and the *value* is the value of the form field.

The form can be saved with the `EasyFormSaveButton` or by calling `EasyForm.of(context).save()`.

To insert a text field, the `EasyTextFormField` widget is used, for other fields, you can use the `EasyCustomFormField` widget directly in the widget tree or create its inheritor.

## Table of Contents

- [Example](#example)
- [Data processing](#data-processing)
- [Error handling](#error-handling)
  - [Custom error display](#custom-error-display)
- [Custom fields](#custom-fields)
  - [Stateful custom field](#stateful-custom-field)
- [Form buttons](#form-buttons)
  - [Button customization](#button-customization)
    - [Process of saving a form](#process-of-saving-a-form)
- [Form saving indicator](#form-saving-indicator)

## Example

This example shows a `EasyForm` with two `EasyTextFormField` to enter an username, password and an `EasyFormSaveButton` to submit the form. The values ​​of the form fields are passed to the hypothetical API client, the result of the API request is passed to `onSaved`. While waiting for the API client to finish, the `EasyFormSaveButton`
displays a `CircularProgressIndicator`.

![](https://github.com/andyduke/easy_form_kit/raw/master/screenshots/demo.gif)

```dart
@override
Widget build(BuildContext context) {
  return EasyForm(
    onSave: (values, form) async {
      return API.login(values['username'], values['password']);
    },
    onSaved: (response, values, form) {
      if (response.hasError) {
        // ... display error
      } else {
        // ... navigate to another screen
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        EasyTextFormField(
          name: 'username',
          decoration: const InputDecoration(
            hintText: 'Enter your username',
          ),
          validator: (value) {
            if (value.isEmpty) {
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
          validator: (value) {
            if (value.isEmpty) {
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
  );
}
```

## Data processing

**EasyForm**

During the save of the form, the values from all fields are collected into the `Map<String, dynamic>` and passed to the `onSave` callback.

The `onSave` callback is asynchronous, you can save or send values in it, wait for the response and pass it on to `onSaved`. If `onSave` returns nothing, a map with the values of the form fields will be passed to `onSaved`.

**EasyDataForm<T>**

Unlike `EasyForm`, in `EasyDataForm<T>` the result returned by the `onSave` callback must be of the type (`T`) specified when the `EasyDataForm<T>` was instantiated.

Also, `EasyDataForm<T>` has a different way of handling the result of the `onSave` callback:
- **EasyForm** passes the result from the `onSave` callback to the `onSaved` callback. If the `onSave` result is `null` *(`onSave` returned `null` or `onSave` was not specified)* — instead of the `onSave` result, a map with the values of the form fields will be passed.
- **EasyDataForm** always passes only the result returned by the `onSave` callback to the `onSaved` callback, or `null` if `onSave` was not specified.


## Error handling

If you need to pass errors to fields received from outside, for example, through the API, you can use the `errors` parameter of the `EasyForm` constructor or the `setErrors` method of `EasyFormState`.

An example of using the `errors` parameter of the `EasyForm` constructor:
```dart
class SampleFormPage extends StatefulWidget {
  @override
  _SampleFormPageState createState() => _SampleFormPageState();
}

class _SampleFormPageState extends State<SampleFormPage> {
  Map<String, String> errors;

  @override
  Widget build(BuildContext context) {
    return EasyForm(
      errors: errors, // This is where errors are set in the fields.
      onSave: (values, form) async {
        return API.login(values['username'], values['password']);
      },
      onSaved: (response, values, form) {
        if (response.hasError) {
          setState(() {
            errors = response.fieldsErrors;
          });
        } else {
          // ... navigate to another screen
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          EasyTextFormField(
            name: 'username',
            decoration: const InputDecoration(
              hintText: 'Enter your username',
            ),
            validator: (value) {
              if (value.isEmpty) {
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
            validator: (value) {
              if (value.isEmpty) {
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
    );
  }
}
```

An example of using the `setErrors` method in `EasyFormState`:
```dart
class SampleFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyForm(
      onSave: (values, form) async {
        return API.login(values['username'], values['password']);
      },
      onSaved: (response, values, form) {
        if (response.hasError) {
          form.setErrors(response.fieldsErrors); // This is where errors are set in the fields.
        } else {
          // ... navigate to another screen
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          EasyTextFormField(
            name: 'username',
            decoration: const InputDecoration(
              hintText: 'Enter your username',
            ),
            validator: (value) {
              if (value.isEmpty) {
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
            validator: (value) {
              if (value.isEmpty) {
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
    );
  }
}
```

### Custom error display

For non-standard display of errors, or for displaying an error elsewhere in the layout, you can use the `EasyFormFieldError` widget.

For example, in the following example, the error message is displayed below a layout that contains a custom field:
```dart
class CustomErrorDisplayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyForm(
      onSave: (values, form) async {
        return {
          'file': 'Invalid file.',
        };
      },
      onSaved: (response, values, form) {
        if (response != null) {
          form.setErrors(response);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              // Custom form field.
              DocumentFormField(
                name: 'file',
              ),
              const SizedBox(width: 16),
              Text('Document to upload.'),
            ],
          ),

          // An error message will be displayed here.
          EasyFormFieldError(
            name: 'file',
            textStyle: TextStyle(color: Colors.red),
          ),

          const Divider(
            height: 24,
          ),

          EasyTextFormField(
            name: 'username',
            decoration: const InputDecoration(
              hintText: 'Enter your username',
            ),
            validator: (value) {
              if (value.isEmpty) {
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
            validator: (value) {
              if (value.isEmpty) {
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
    );
  }
}
```

## Custom fields

For text fields, you can use the `EasyTextFormField` widget, which encapsulates the `TextField` widget with all its properties.

`EasyForm` makes it easy to create a custom type of form field.

As a controller, you can use the generic `EasyFormFieldController` or create an inheritor of it:
```dart
class ColorController extends EasyFormFieldController<Color> {
  ColorController(Color value) : super(value);
}
```

To create a field, you can create an inheritor of `EasyFormGenericField` and implement its `build` method:
```dart
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
```

This field and controller can be used independently of `EasyForm`.

To use them in `EasyForm`, you can do it directly through the generic-widget of the `EasyCustomFormField`:
```dart
EasyCustomFormField<Color, ColorController>(
  name: 'color',
  initialValue: Colors.teal,
  controllerBuilder: (value) => ColorController(value),
  builder: (fieldState, onChangedHandler) => ColorField(
    controller: fieldState.controller,
    onChange: onChangedHandler,
  ),
),
```

Or create an inheritor of the `EasyCustomFormField` widget:
```dart
class ColorFormField extends EasyCustomFormField<Color, ColorController> {
  ColorFormField({
    Key key,
    @required String name,
    ColorController controller,
    Color initialValue,
  }) : super(
          key: key,
          name: name,
          controller: controller,
          initialValue: initialValue ?? Color(0x00000000),
          controllerBuilder: (value) => ColorController(value),
          builder: (state, onChangedHandler) {
            return ColorField(
              controller: state.controller,
              onChange: onChangedHandler,
            );
          },
        );
}
```
... and use it in the form:
```dart
ColorFormField(
  name: 'color',
  initialValue: Colors.teal,
),
```

### Stateful custom field

The `EasyFormGenericField` widget is a stateful widget, if you need to store an intermediate state (for example, a link to a photo picker), this is how you can transform the above field code into a stateful widget:
```dart
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

  @override
  ColorFieldState createState() => ColorFieldState();
}

class ColorFieldState extends EasyFormGenericFieldState<Color> {
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
```

## Form buttons

For convenience, `EasyForm` has three types of buttons:
* `EasyFormSaveButton` - to save the form;
* `EasyFormResetButton` - to return the form to its original state;
* `EasyFormButton` - for any form action;

The `EasyFormSaveButton` and `EasyFormResetButton` buttons each have two constructors, one - the standard one accepts the widget as the button content, and the second named `text` accepts the text as the button content:
```dart
EasyFormSaveButton(child: Text('Save')),
// or
EasyFormSaveButton.text('Save'),
```

### Button customization

By default, the `EasyFormSaveButton` is created as an `ElevatedButton` or `CupertinoButton.filled`, and the `EasyFormResetButton` is created as an `OutlinedButton` or `CupertinoButton`.

The appearance of the button can be customized using the `adaptivity` argument of the `EasyForm` constructor:
* `EasyFormAdaptivity.auto` - the button type will be selected based on the platform;
* `EasyFormAdaptivity.material` - Material-design buttons;
* `EasyFormAdaptivity.cupertion` - Apple design buttons. 

These buttons can be customized by overriding the button `builder` that creates the button widget itself.

The builder can be passed to the constructor:
```dart
EasyFormSaveButton.text(
  'Save',
  builder: (context, key, child, onPressed) => ElevatedButton(
    key: key,
    child: child,
    onPressed: onPressed,
  ),
),
```
... or redefine globally, for the entire application (except for those buttons where the builder is passed to the constructor):
```dart
EasyFormSaveButton.defaultBuilder = (context, key, child, onPressed) => ElevatedButton(
  key: key,
  child: child,
  onPressed: onPressed,
);
```

#### Process of saving a form

While the form is being saved, the `EasyFormSaveButton` and `EasyFormResetButton` buttons are blocked from being pressed, and a progress indicator is displayed on the `EasyFormSaveButton` button instead of its content (for example, text).

By default, the indicator is an 18x18 `CircularProgressIndicator` or `CupertinoActivityIndicator` and the color of the text from the `ElevatedButton`.

It can be customized by overriding the builder in the button constructor:
```dart
EasyFormSaveButton.text(
  'Save',
  indicatorBuilder: (context, size) => SizedBox.fromSize(
    size: size,
    child: CircularProgressIndicator.adaptive(
      strokeWidth: 2,
    ),
  ),
)
```

... or redefine globally, for the entire application (except for those buttons where the builder is passed to the constructor):
```dart
EasyFormSaveButton.defaultIndicatorBuilder = (context, size) => SizedBox.fromSize(
  size: size,
  child: CircularProgressIndicator.adaptive(
    strokeWidth: 2,
  ),
);
```

## Form saving indicator

Saving or submitting form data can take a certain amount of time, during which time a progress indicator can be displayed. If you are not using an `EasyFormSaveButton` button that shows such an indicator, you may want to add such an indicator on top of all or part of the form. The `EasyFormSaveIndicator` widget is used for this.

By default, this is `CircularProgressIndicator` or `CupertinoActivityIndicator` over the `child` of the widget, but you can override the indicator builder, as well as override the layout builder so that the indicator is not placed on top of the child.

The indicator builder and layout builder can be passed to the `EasyFormSaveIndicator` constructor or assigned globally for the entire application (except for `EasyFormSaveIndicator`, with the specified builder in the constructor) via `EasyFormSaveIndicator.defaultIndicatorBuilder` and `EasyFormSaveIndicator.defaultLayoutBuilder`.
