import 'package:flutter/widgets.dart';
import 'package:easy_form_kit/src/easy_form.dart';

/// A typed result form to be returned by the `onSave` callback and passed as a parameter to the `onSaved` callback.
///
/// The main difference between `EasyDataForm<T>` and `EasyForm` is as follows:
/// - **EasyForm** passes the result from the `onSave` callback to the `onSaved` callback.
///   If the `onSave` result is `null` *(`onSave` returned `null` or `onSave` was not specified)* — instead of the
///   `onSave` result, a map with the values of the form fields will be passed.
/// - **EasyDataForm** always passes only the result returned by the `onSave` callback to the `onSaved` callback,
///   or `null` if `onSave` was not specified.
///
/// See also:
///
///  * [EasyForm], for a more detailed description and examples of using forms in the easy_form_kit package.
class EasyDataForm<T> extends EasyForm {
  /// Creates a container for form fields.
  ///
  /// The [child] argument must not be null.
  EasyDataForm({
    Key? key,
    required Widget child,
    EasyFormAdaptivity adaptivity = EasyForm.defaultAdaptivity,
    @Deprecated(
        'Use PopScope around EasyForm instead. Will be removed in the next major release.')
    WillPopCallback? onWillPop,
    EasyFormChangeCallback? onChanged,
    EasyFormFieldSaveCallback<T>? onSave,
    EasyFormFieldSavedCallback<T?>? onSaved,
    EasyAutovalidateMode autovalidateMode = EasyForm.defaultAutovalidateMode,
    Map<String, String?>? errors,
    Duration scrollToFieldDuration = EasyForm.defaultScrollToFieldDuration,
    Curve scrollToFieldCurve = EasyForm.defaultScrollToFieldCurve,
  }) : super(
          key: key,
          child: child,
          adaptivity: adaptivity,
          onWillPop: onWillPop,
          onChanged: onChanged,
          onSave: onSave,
          onSaved: (values, fieldValues, form) =>
              onSaved?.call(values, fieldValues, form),
          autovalidateMode: autovalidateMode,
          errors: errors,
          scrollToFieldDuration: scrollToFieldDuration,
          scrollToFieldCurve: scrollToFieldCurve,
        );

  @override
  EasyDataFormState<T> createState() => EasyDataFormState<T>();
}

/// State associated with a [EasyDataForm] widget.
///
/// A [EasyDataFormState] object can be used to [save], [reset], and [validate] every
/// [EasyFormField] that is a descendant of the associated [EasyForm].
///
/// Typically obtained via [EasyForm.of].
class EasyDataFormState<T> extends EasyFormState {
  @override
  Future<void> doSave(Map<String, dynamic> values) async {
    final T? data = await widget.onSave?.call(values, this);
    widget.onSaved?.call(data, values, this);
  }
}
