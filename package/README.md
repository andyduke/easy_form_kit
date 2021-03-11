# EasyForm

A set of widgets for processing form field data in one common processor. Convenient for saving data to a database, sending via API, etc.

`EasyForm` and `EasyTextFormField` widgets are similar to and closely compatible with Flutter's `Form` and `TextFormField` widgets.

Form field widgets are placed in an `EasyForm` container, each field has a name (specified in the `name` parameter), when saved, the form field data is passed to the `onSave` callback as a `Map<String, dynamic>`, where the *key* is the field name and the *value* is the value of the form field.

The form can be saved with the `EasyFormSaveButton` or by calling `EasyForm.of(context).save()`.

To insert a text field, the `EasyTextFormField` widget is used, for other fields, you can use the `EasyCustomFormField` widget directly in the widget tree or create its inheritor.

### Example

This example shows a `EasyForm` with two `EasyTextFormField` to enter an username, password and an `EasyFormSaveButton` to submit the form. The values ​​of the form fields are passed to the hypothetical API client, the result of the API request is passed to `onSaved`. While waiting for the API client to finish, the `EasyFormSaveButton`
displays a `CircularProgressIndicator`.

![](https://github.com/andyduke/easy_form_kit/raw/master/screenshots/demo.gif)

```dart
@override
Widget build(BuildContext context) {
  return EasyForm(
    onSave: (values) async {
      return API.login(values['username'], values['password']);
    },
    onSaved: (response) {
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

During the save of the form, the values from all fields are collected into the `Map<String, dynamic>` and passed to the `onSave` callback.

The `onSave` callback is asynchronous, you can save or send values in it, wait for the response and pass it on to `onSaved`. If `onSave` returns nothing, a map with the values of the form fields will be passed to `onSaved`.

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

## EasyFormSaveIndicator

TODO:
