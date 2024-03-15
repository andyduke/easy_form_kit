import 'package:flutter/foundation.dart';

/// Base controller class for use with custom form fields.
///
/// It can be used as an ancestor for a controller of a
/// specific type, or directly without creating a descendant:
/// ```dart
/// EasyCustomFormField<Color, EasyFormFieldController<Color>>(
///   name: 'color',
///   initialValue: Colors.teal,
///   controllerBuilder: (value) => EasyFormFieldController<Color>(value),
///   builder: (fieldState, onChangedHandler) => ColorField(
///     controller: fieldState.controller,
///     onChange: onChangedHandler,
///   ),
/// )
/// ```
///
/// See also:
///
///  * [EasyFormGenericField] for a usage example.
class EasyFormFieldController<T> extends ValueNotifier<T?> {
  T? _value;

  EasyFormFieldController(T? value)
      : _value = value,
        super(value);

  EasyFormFieldController.fromValue(T? value) : super((value ?? null) as T?);

  T? get value => _value;

  set value(T? newValue) {
    _value = newValue;
    notifyListeners();
  }
}
