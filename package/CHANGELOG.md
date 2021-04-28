## 2.1.1

* Fixed bug in `EasyCustomFormField` when returning null in `valueGet`.
* Fixed bug in `EasyTextFormField` using external controller.

## 2.1.0+1

* The `errors` property has been added to `EasyForm` and the `setErrors` method has been added to `EasyFormState`, for the ability to set errors in some fields, for example, received through the API.

## 2.0.0

* Release of the null-safety version. 

## 2.0.0-nullsafety.2

### `EasyCustomFormField`:
* `valueGet` & `valueSet` now accept a nullable `value` parameter.
* `controllerBuilder` & `recreateController` now return a non-null controller type.
* `setValue` now accepts a nullable `value` parameter.
* The `builder` callback now accepts a non-null controller type.

## 2.0.0-nullsafety.1

* Now the return type of `EasyFormFieldValidator` is `String?`, i.e. allows you to return `null` if the validation is successful.

## 2.0.0-nullsafety.0

* Migrate to null safety.

## 1.0.9

* Added `value` and `controller` properties to `EasyFormGenericFieldState` to access the current field value and its controller. 

## 1.0.8+1

* **Breaking changes:** `EasyForm` adds a second parameter to the `onSave` callback and a third parameter to the `onSaved` callback, the state of the form itself.

## 1.0.7

* The `saveOnSubmit` argument has been added to `EasyTextFormField`, which, when true, the form is saved by pressing *submit* on the keyboard.
* A `saveForm` method has been added to `EasyFormFieldState` to save the form.

## 1.0.6

* Added exception handling in `onSave` and `onSaved` callbacks.

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
