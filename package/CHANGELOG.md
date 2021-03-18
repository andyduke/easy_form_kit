## 1.0.5

* The `build` method of the `EasyFormGenericField` widget now has a default implementation that throws a `UnimplementedError`. Now it is not necessary to implement this method if the class inherited from `EasyFormGenericFieldState` has its own implementation of the `build` method.

## 1.0.4

* State class `EasyFormGenericFieldState` made public.

## 1.0.3+1

* **Breaking changes:** A second parameter has been added to the signature of `EasyFormFieldValidator`, which contains the values of all fields of the form.

## 1.0.2

* **Breaking changes:** `EasyForm` adds a second parameter to the `onSaved` callback, form field values.

## 1.0.1

* Added `EasyTextFormField.builder` constructor.

## 1.0.0+1

* Initial version.
