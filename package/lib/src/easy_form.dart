import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Enumeration of the modes of adaptability of form elements
enum EasyFormAdaptivity {
  auto,
  material,
  cupertino,
}

/// A container for grouping together multiple form field widgets
/// (e.g. [TextField] widgets) and handling all of the form field values
/// in a single callback.
///
/// Each individual form field should be wrapped in a [EasyFormField] widget,
/// with the [EasyForm] widget as a common ancestor of all of those.
/// For text fields, it's convenient to use the [EasyTextFormField] widget,
/// which encapsulates the [TextField] widget inside itself.
///
/// To save and reset form fields, place the [EasyFormSaveButton] and
/// [EasyFormResetButton] buttons in the underlying widget tree,
/// or сall methods on [EasyFormState] to `save`, `reset`, or `validate`
/// each [EasyFormField] that is a descendant of this [EasyForm].
/// To obtain the [EasyFormState], you may use [EasyForm.of] with a context
/// whose ancestor is the [EasyForm], pass a [GlobalKey] to the [EasyForm]
/// constructor and call [GlobalKey.currentState] or use the [EasyFormButton]
/// widget, which has `builder` callback, accepting [EasyFormState].
///
/// When the form is saved, all field values ​​are passed to the `onSave`
/// callback as a `Map<String, dynamic>`, where you can save these values
/// ​​to the database, pass them to the API, etc. The `onSave` callback is
/// asynchronous and can return the modified values ​​of the form fields.
/// After the `onSave` callback completes, the `onSaved` callback
/// will be called with the values ​​returned from `onSave`.
///
///
/// This example shows a [EasyForm] with two [EasyTextFormField] to enter an
/// username, password and an [EasyFormSaveButton] to submit the form.
/// The values ​​of the form fields are passed to the hypothetical API client,
/// the result of the API request is passed to `onSaved`.
/// While waiting for the API client to finish, the [EasyFormSaveButton]
/// displays a [CircularProgressIndicator].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return EasyForm(
///     onSave: (values, form) async {
///       return API.login(values['username'], values['password']);
///     },
///     onSaved: (response, values, form) {
///       if (response.hasError) {
///         // ... display error
///       } else {
///         // ... navigate to another screen
///       }
///     },
///     child: Column(
///       crossAxisAlignment: CrossAxisAlignment.start,
///       children: <Widget>[
///         EasyTextFormField(
///           name: 'username',
///           decoration: const InputDecoration(
///             hintText: 'Enter your username',
///           ),
///           validator: (value) {
///             if (value.isEmpty) {
///               return 'Please enter some text';
///             }
///             return null;
///           },
///         ),
///         const SizedBox(height: 16.0),
///         EasyTextFormField(
///           name: 'password',
///           decoration: const InputDecoration(
///             hintText: 'Enter your password',
///           ),
///           validator: (value) {
///             if (value.isEmpty) {
///               return 'Please enter some text';
///             }
///             return null;
///           },
///         ),
///         Padding(
///           padding: const EdgeInsets.symmetric(vertical: 24.0),
///           child: EasyFormSaveButton.text('Sign In'),
///         ),
///       ],
///     ),
///   );
/// }
/// ```
///
/// See also:
///
///  * [GlobalKey], a key that is unique across the entire app.
///  * [EasyFormField], a single form field widget that maintains the current state.
///  * [EasyTextFormField], a convenience widget that wraps a [TextField] widget in a [EasyFormField].
///  * [EasyFormSaveButton], a button widget that sends form field values ​​to `onSave` and displays
///    an indicator while the values ​​are processed in `onSave`.
///
class EasyForm extends StatefulWidget {
  /// Creates a container for form fields.
  ///
  /// The [child] argument must not be null.
  const EasyForm({
    Key? key,
    required this.child,
    this.adaptivity = EasyFormAdaptivity.auto,
    this.onWillPop,
    this.onChanged,
    this.onSave,
    this.onSaved,
    this.autovalidateMode = EasyAutovalidateMode.disabled,
    this.errors,
    this.scrollToFieldDuration = const Duration(milliseconds: 300),
    this.scrollToFieldCurve = Curves.easeOut,
  }) : super(key: key);

  /// Returns the closest [EasyFormState] which encloses the given context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// EasyFormState form = EasyForm.of(context);
  /// form.save();
  /// ```
  static EasyFormState? of(BuildContext context) {
    final _FormScope? scope =
        context.dependOnInheritedWidgetOfExactType<_FormScope>();
    return scope?._formState;
  }

  /// The mode of adaptability of form elements, in which design system
  /// the form elements will be displayed: Material, Apple, or
  /// will be automatically determined based on the platform.
  final EasyFormAdaptivity adaptivity;

  /// The widget below this widget in the tree.
  ///
  /// This is the root of the widget hierarchy that contains this form.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// Enables the form to veto attempts by the user to dismiss the [ModalRoute]
  /// that contains the form.
  ///
  /// If the callback returns a Future that resolves to false, the form's route
  /// will not be popped.
  ///
  /// See also:
  ///
  ///  * [WillPopScope], another widget that provides a way to intercept the
  ///    back button.
  final WillPopCallback? onWillPop;

  /// Called when one of the form fields changes.
  ///
  /// In addition to this callback being invoked, all the form fields themselves
  /// will rebuild.
  final EasyFormChangeCallback? onChanged;

  /// Called when the form is being saved using the `save` method or
  /// the [EasyFormSaveButton] button.
  ///
  /// A map with all the values of the form fields is passed as a parameter.
  /// All fields [EasyFormField], [EasyFormTextField], etc. have a mandatory
  /// `name` parameter, which is used as the name of the field in the map.
  ///
  /// The callback is asynchronous, for example, you can pass the form data to
  /// the API and wait for the result of the request, the result can be returned
  /// and it will be passed to `onSaved`.
  final EasyFormFieldSaveCallback? onSave;

  /// Called after the `onSave` callback completes, the result from `onSave`
  /// is passed to `onSaved` as a parameter.
  final EasyFormFieldSavedCallback? onSaved;

  /// Used to enable/disable form fields auto validation and update their error
  /// text.
  ///
  /// {@macro flutter.widgets.form.autovalidateMode}
  final EasyAutovalidateMode autovalidateMode;

  /// Sets errors in fields as a Map, where key is the name of the field and
  /// value is the text of the error message.
  ///
  /// Can be null if there are no errors.
  final Map<String, String?>? errors;

  /// Duration of scrolling to the error field.
  final Duration scrollToFieldDuration;

  /// Scroll curve to field with error.
  final Curve scrollToFieldCurve;

  @override
  EasyFormState createState() => EasyFormState();
}

/// State associated with a [EasyForm] widget.
///
/// A [EasyFormState] object can be used to [save], [reset], and [validate] every
/// [EasyFormField] that is a descendant of the associated [EasyForm].
///
/// Typically obtained via [EasyForm.of].
class EasyFormState extends State<EasyForm> {
  final ValueNotifier<bool> _isSaving = ValueNotifier(false);

  EasyFormAdaptivity? _adaptivity;

  int _generation = 0;
  bool _hasInteractedByUser = false;
  final Set<EasyFormFieldState<dynamic>> _fields =
      <EasyFormFieldState<dynamic>>{};

  Set<EasyFormFieldState<dynamic>> get fields => _fields;

  ValueNotifier<bool> get isSaving => _isSaving;

  Map<String, String?>? errors;

  /// The mode of adaptability of form elements, in which design system
  /// the form elements will be displayed: Material, Apple, or
  /// will be automatically determined based on the platform.
  EasyFormAdaptivity get adaptivity => _adaptivity ?? EasyFormAdaptivity.auto;

  @override
  void didChangeDependencies() {
    errors = widget.errors;

    if (_adaptivity == null) {
      _adaptivity = widget.adaptivity;
      if (_adaptivity == EasyFormAdaptivity.auto) {
        final TargetPlatform platform = Theme.of(context).platform;
        switch (platform) {
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
            _adaptivity = EasyFormAdaptivity.material;
            break;

          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            _adaptivity = EasyFormAdaptivity.cupertino;
            break;

          case TargetPlatform.linux:
            _adaptivity = EasyFormAdaptivity.material;
            break;

          case TargetPlatform.windows:
            _adaptivity = EasyFormAdaptivity.material;
            break;
        }
      }
    }

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant EasyForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.errors != widget.errors) {
      errors = widget.errors;
    }
  }

  // Called when a form field has changed. This will cause all form fields
  // to rebuild, useful if form fields have interdependencies.
  void _fieldDidChange(EasyFormFieldState<dynamic>? field) {
    widget.onChanged?.call(field);

    _hasInteractedByUser = _fields
        .any((EasyFormFieldState<dynamic> field) => field._hasInteractedByUser);
    _forceRebuild();
  }

  void _forceRebuild() {
    setState(() {
      ++_generation;
    });
  }

  void _register(EasyFormFieldState<dynamic> field) {
    final String? fieldError = errors?[field.name];
    if (fieldError != null) {
      field._setErrorText(fieldError);
    }

    _fields.add(field);
  }

  void _unregister(EasyFormFieldState<dynamic> field) {
    _fields.remove(field);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.autovalidateMode) {
      case EasyAutovalidateMode.always:
        _validate();
        break;
      case EasyAutovalidateMode.onUserInteraction:
        if (_hasInteractedByUser) {
          _validate();
        }
        break;
      case EasyAutovalidateMode.disabled:
        break;
    }

    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: _FormScope(
        formState: this,
        generation: _generation,
        child: widget.child,
      ),
    );
  }

  /// Sets errors in fields as a Map, where key is the name of the field and
  /// value is the text of the error message.
  ///
  /// Can be null if there are no errors.
  void setErrors(Map<String, String?>? newErrors) {
    errors = newErrors;

    EasyFormFieldState? errorField;

    for (final EasyFormFieldState<dynamic> field in _fields) {
      if (errors != null && errors!.containsKey(field.name)) {
        final bool hasError = errors![field.name]?.isNotEmpty ?? false;
        if (hasError && errorField == null) errorField = field;

        field._setErrorText(errors![field.name], silent: true);
      } else {
        field._setErrorText(null, silent: true);
      }
    }

    _focusField(errorField);

    _forceRebuild();
  }

  /// Returns the values of form fields as a Map<String, dynamic>
  Map<String, dynamic> values() {
    final Map<String, dynamic> values = {};

    for (final EasyFormFieldState<dynamic> field in _fields) {
      values[field.name] = field.value;
    }

    return values;
  }

  /// Validate & saves every [EasyFormField] that is a descendant of this [EasyForm].
  Future<bool> save() async {
    if (!validate()) return false;

    final Map<String, dynamic> values = {};

    for (final EasyFormFieldState<dynamic> field in _fields) {
      field.save();
      values[field.name] = field.value;
    }

    _isSaving.value = true;
    try {
      final dynamic data = await widget.onSave?.call(values, this);
      widget.onSaved?.call(data ?? values, values, this);
    } finally {
      _isSaving.value = false;
    }

    return true;
  }

  /// Resets every [EasyFormField] that is a descendant of this [EasyForm] back to its
  /// [EasyFormField.initialValue].
  ///
  /// The [EasyForm.onChanged] callback will be called.
  ///
  /// If the form's [EasyForm.autovalidateMode] property is [EasyAutovalidateMode.always],
  /// the fields will all be revalidated after being reset.
  void reset() {
    for (final EasyFormFieldState<dynamic> field in _fields) field.resetValue();
    _hasInteractedByUser = false;
    _fieldDidChange(null);
  }

  void _resetFocus() {
    for (final EasyFormFieldState<dynamic> field in _fields) {
      field.unfocus();
    }
  }

  void _resetErrors() {
    for (final EasyFormFieldState<dynamic> field in _fields) {
      if (errors != null && errors!.containsKey(field.name)) {
        errors!.remove(field.name);
      }
      field._setErrorText(null, silent: true);
    }
  }

  /// Validates every [EasyFormField] that is a descendant of this [EasyForm], and
  /// returns true if there are no errors.
  ///
  /// The form will rebuild to report the results.
  bool validate() {
    _resetFocus();
    _resetErrors();

    _hasInteractedByUser = true;
    _forceRebuild();
    final EasyFormFieldState<dynamic>? errorField = _validate();

    _focusField(errorField);

    return errorField == null;
  }

  EasyFormFieldState<dynamic>? _validate() {
    final _values = values();
    EasyFormFieldState<dynamic>? errorField;
    for (final EasyFormFieldState<dynamic> field in _fields) {
      if (!field.validate(_values) && (errorField == null)) {
        errorField = field;
      }
    }
    return errorField;
  }

  Future<void> _focusField(EasyFormFieldState? field) async {
    if (field == null) return;

    await _scrollToField(field);
    field.focus();
  }

  Future<void> _scrollToField(EasyFormFieldState field) async {
    final ScrollableState? scrollableState = Scrollable.of(context);
    if (scrollableState == null) return;

    final RenderObject? object = context.findRenderObject();
    if (object == null) return;

    final RenderAbstractViewport? viewport = RenderAbstractViewport.of(object);
    if (viewport == null) return;

    ScrollPosition position = scrollableState.position;
    double alignment;

    if (position.pixels > viewport.getOffsetToReveal(object, 0.0).offset) {
      // Move down to the top of the viewport
      alignment = 0.0;
    } else if (position.pixels <
        viewport.getOffsetToReveal(object, 1.0).offset) {
      // Move up to the bottom of the viewport
      alignment = 1.0;
    } else {
      // No scrolling is necessary to reveal the child
      return;
    }

    position.ensureVisible(
      object,
      alignment: alignment,
      duration: widget.scrollToFieldDuration,
      curve: widget.scrollToFieldCurve,
    );
  }

  /// Returns [EasyFormFieldState] for the field named `name`,
  /// if no such field is found, returns null.
  EasyFormFieldState? fieldByName(String name) {
    final field = fields.cast<EasyFormFieldState?>().firstWhere(
          (field) => field?.name == name,
          orElse: () => null,
        );
    return field;
  }
}

class _FormScope extends InheritedWidget {
  const _FormScope({
    Key? key,
    required Widget child,
    required EasyFormState formState,
    required int generation,
  })   : _formState = formState,
        _generation = generation,
        super(key: key, child: child);

  final EasyFormState _formState;

  /// Incremented every time a form field has changed. This lets us know when
  /// to rebuild the form.
  final int _generation;

  /// The [EasyForm] associated with this widget.
  EasyForm get form => _formState.widget;

  @override
  bool updateShouldNotify(_FormScope old) => _generation != old._generation;
}

/// Signature for save callback.
///
/// A map with all the values of the form fields is passed as a parameter.
/// All fields [EasyFormField], [EasyFormTextField], etc. have a mandatory
/// `name` parameter, which is used as the name of the field in the map.
typedef EasyFormFieldSaveCallback = Future<dynamic> Function(
    Map<String, dynamic> values, EasyFormState form);

/// Signature for saved callback.
///
/// Called after the `onSave` callback completes, the result from `onSave`
/// is passed to `onSaved` as the first parameter and the map with all the values
/// of the form fields is passed as the second parameter.
typedef EasyFormFieldSavedCallback = void Function(
    dynamic values, Map<String, dynamic> fieldValues, EasyFormState form);

/// Signature for the callback when the field changes.
typedef EasyFormChangeCallback = void Function(
    EasyFormFieldState<dynamic>? field);

// --- EasyFormField

/// Signature for validating a form field.
///
/// Returns an error string to display if the input is invalid, or null
/// otherwise.
///
/// Used by [EasyFormField.validator].
typedef EasyFormFieldValidator<T> = String? Function(T value,
    [Map<String, dynamic>? values]);

/// Signature for being notified when a form field changes value.
///
/// Used by [EasyFormField.onSaved].
typedef EasyFormFieldSetter<T> = void Function(T newValue);

/// Signature for building the widget representing the form field.
///
/// Used by [EasyFormField.builder].
typedef EasyFormFieldBuilder<T> = Widget Function(EasyFormFieldState<T> field);

/// A single form field.
///
/// The `name` field is required to set the key in the map for onSave in
/// the [EasyForm] widget.
///
/// This widget maintains the current state of the form field, so that updates
/// and validation errors are visually reflected in the UI.
///
/// When used inside a [EasyForm], you can use methods on [EasyFormState] to query or
/// manipulate the form data as a whole. For example, calling [EasyFormState.save]
/// will invoke each [EasyFormField]'s [onSaved] callback in turn.
///
/// Use a [GlobalKey] with [EasyFormField] if you want to retrieve its current
/// state, for example if you want one form field to depend on another.
///
/// A [EasyForm] ancestor is not required. The [EasyForm] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [EasyForm],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// See also:
///
///  * [EasyForm], which is the widget that aggregates the form fields.
///  * [TextField], which is a commonly used form field for entering text.
///  * [EasyTextFormField], a convenience widget that wraps a [TextField] widget
///    in a [EasyFormField].
class EasyFormField<T> extends StatefulWidget {
  /// Creates a single form field.
  ///
  /// The [name] and [builder] arguments must not be null.
  const EasyFormField({
    Key? key,
    required this.name,
    required this.builder,
    this.focusNode,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.enabled = true,
    this.autovalidateMode = EasyAutovalidateMode.disabled,
  }) : super(key: key);

  /// Name of the field.
  ///
  /// The field name is used to set the key in the map with all the form values
  /// that are passed to the [onSave] of the [EasyForm] widget.
  final String name;

  /// Focus node.
  final FocusNode? focusNode;

  /// An optional method to call with the final value when the form is saved via
  /// [EasyFormState.save].
  final EasyFormFieldSetter<T>? onSaved;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  ///
  /// The returned value is exposed by the [EasyFormFieldState.errorText] property.
  /// The [EasyTextFormField] uses this to override the [InputDecoration.errorText]
  /// value.
  ///
  /// Alternating between error and normal state can cause the height of the
  /// [EasyTextFormField] to change if no other subtext decoration is set on the
  /// field. To create a field whose height is fixed regardless of whether or
  /// not an error is displayed, either wrap the [EasyTextFormField] in a fixed
  /// height parent like [SizedBox], or set the [InputDecoration.helperText]
  /// parameter to a space.
  final EasyFormFieldValidator<T>? validator;

  /// Function that returns the widget representing this form field. It is
  /// passed the form field state as input, containing the current value and
  /// validation state of this field.
  final EasyFormFieldBuilder<T> builder;

  /// An optional value to initialize the form field to, or null otherwise.
  final T? initialValue;

  /// Whether the form is able to receive user input.
  ///
  /// Defaults to true. If [autovalidateMode] is not [EasyAutovalidateMode.disabled],
  /// the field will be auto validated. Likewise, if this field is false, the widget
  /// will not be validated regardless of [autovalidateMode].
  final bool enabled;

  /// Used to enable/disable this form field auto validation and update its
  /// error text.
  ///
  /// {@template flutter.widgets.form.autovalidateMode}
  /// If [EasyAutovalidateMode.onUserInteraction] this form field will only
  /// auto-validate after its content changes, if [EasyAutovalidateMode.always] it
  /// will auto validate even without user interaction and
  /// if [EasyAutovalidateMode.disabled] the auto validation will be disabled.
  ///
  /// Defaults to [EasyAutovalidateMode.disabled] if `autovalidate` is false which
  /// means no auto validation will occur. If `autovalidate` is true then this
  /// is set to [EasyAutovalidateMode.always] for backward compatibility.
  /// {@endtemplate}
  final EasyAutovalidateMode autovalidateMode;

  @override
  EasyFormFieldState<T> createState() => EasyFormFieldState<T>();
}

/// The current state of a [EasyFormField]. Passed to the [EasyFormFieldBuilder] method
/// for use in constructing the form field's widget.
class EasyFormFieldState<T> extends State<EasyFormField<T?>> {
  T? _value;
  String? _errorText;
  bool _hasInteractedByUser = false;

  FocusNode? _focusNode;
  FocusNode get focusNode {
    return widget.focusNode ?? (_focusNode ??= FocusNode());
  }

  /// Name of the field.
  String get name => widget.name;

  /// The current value of the form field.
  T? get value => _value;

  /// The current validation error returned by the [EasyFormField.validator]
  /// callback, or null if no errors have been triggered. This only updates when
  /// [validate] is called.
  String? get errorText => _errorText;

  void _setErrorText(String? error, {bool silent = false}) {
    _errorText = error;
    if (!silent) setState(() {});
  }

  /// True if this field has any validation errors.
  bool get hasError => _errorText != null;

  /// True if the current value is valid.
  ///
  /// This will not set [errorText] or [hasError] and it will not update
  /// error display.
  ///
  /// See also:
  ///
  ///  * [validate], which may update [errorText] and [hasError].
  bool get isValid => _validate() == null;

  /// Sets the input focus to this field.
  void focus() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
      scheduleMicrotask(() {
        focusNode.requestFocus();
      });
    } else {
      focusNode.requestFocus();
    }
  }

  /// Removes input focus from this field.
  void unfocus() {
    focusNode.unfocus();
  }

  /// Calls the [EasyFormField]'s onSaved method with the current value.
  void save() {
    widget.onSaved?.call(value);
  }

  /// Validate & saves form.
  Future<bool> saveForm() async {
    return EasyForm.of(context)?.save() ?? Future.value(false);
  }

  @mustCallSuper
  @protected
  void resetValue() {
    setState(() {
      _value = widget.initialValue;
      _hasInteractedByUser = false;
      _errorText = null;
    });
  }

  /// Resets the field to its initial value.
  void reset() {
    resetValue();
    EasyForm.of(context)?._fieldDidChange(this);
  }

  /// Calls [EasyFormField.validator] to set the [errorText]. Returns true if there
  /// were no errors.
  ///
  /// See also:
  ///
  ///  * [isValid], which passively gets the validity without setting
  ///    [errorText] or [hasError].
  bool validate([Map<String, dynamic>? values]) {
    setState(() {
      _validate(values);
    });
    return !hasError;
  }

  String? _validate([Map<String, dynamic>? values]) {
    if (values == null) {
      values = EasyForm.of(context)?.values();
    }

    return _errorText = widget.validator?.call(_value, values);
  }

  /// Updates this field's state to the new value. Useful for responding to
  /// child widget changes, e.g. [Slider]'s [Slider.onChanged] argument.
  ///
  /// Triggers the [EasyForm.onChanged] callback and, if [EasyForm.autovalidateMode] is
  /// [EasyAutovalidateMode.always] or [EasyAutovalidateMode.onUserInteraction],
  /// revalidates all the fields of the form.
  void didChange(T value) {
    setState(() {
      _value = value;
      _hasInteractedByUser = true;
    });
    EasyForm.of(context)?._fieldDidChange(this);
  }

  /// Sets the value associated with this form field.
  ///
  /// This method should be only be called by subclasses that need to update
  /// the form field value due to state changes identified during the widget
  /// build phase, when calling `setState` is prohibited. In all other cases,
  /// the value should be set by a call to [didChange], which ensures that
  /// `setState` is called.
  @protected
  void setValue(T value) {
    _value = value;
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void deactivate() {
    EasyForm.of(context)?._unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      switch (widget.autovalidateMode) {
        case EasyAutovalidateMode.always:
          _validate();
          break;
        case EasyAutovalidateMode.onUserInteraction:
          if (_hasInteractedByUser) {
            _validate();
          }
          break;
        case EasyAutovalidateMode.disabled:
          break;
      }
    }
    EasyForm.of(context)?._register(this);
    return widget.builder(this);
  }
}

/// Used to configure the auto validation of [EasyFormField] and [EasyForm] widgets.
enum EasyAutovalidateMode {
  /// No auto validation will occur.
  disabled,

  /// Used to auto-validate [EasyForm] and [EasyFormField] even without user interaction.
  always,

  /// Used to auto-validate [EasyForm] and [EasyFormField] only after each user
  /// interaction.
  onUserInteraction,
}
