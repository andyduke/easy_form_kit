library easy_form;

import 'package:flutter/foundation.dart';

class EasyFormFieldController<T> extends ValueNotifier<T> {
  T _value;

  EasyFormFieldController(T value)
      : _value = value,
        super(value);

  EasyFormFieldController.fromValue(T value) : super(value ?? null);

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}
