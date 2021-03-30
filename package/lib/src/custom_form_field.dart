import 'package:flutter/material.dart';
import 'easy_form.dart';

/// Signature for creating a controller.
typedef CreateControllerCallback<C, T> = C Function(T value);

/// Signature to recreate a controller from an old controller.
typedef RecreateControllerCallback<C> = C Function(C oldController);

/// Signature for value getter from controller.
typedef ValueOfGetter<T, C> = T Function(C controller);

/// Signature for controller value setter.
typedef ValueOfSetter<T, C> = Function(C controller, T value);

/// Field value change handler signature.
typedef EasyFormCustomFieldChangeHandler<T> = void Function(T value);

/// Input field builder signature.
typedef EasyFormCustomFieldBuilder<T, C> = Widget Function(
    _EasyCustomFormFieldState fieldState,
    EasyFormCustomFieldChangeHandler<T> onChangedHandler);

/// An extensible base class for wrapping form fields.
///
/// It is used as a base class for creating fields of custom types,
/// as well as for creating a custom field on the fly in the widget tree.
///
/// For a custom field type, you must specify two general types:
/// the first `T` is the field value type, and the second `C` is
/// the controller type.
///
/// When a [controller] is specified, its [Controller.value]
/// defines the [initialValue]. If this [EasyCustomFormField] is part of a scrolling
/// container that lazily constructs its children, like a [ListView] or a
/// [CustomScrollView], then a [controller] should be specified.
/// The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container.
///
/// If a [controller] is not specified, [initialValue] can be used to give
/// the automatically generated controller an initial value.
///
/// Remember to call [Controller.dispose] of the [Controller]
/// when it is no longer needed. This will ensure we discard any resources used
/// by the object.
///
/// Creates a [EasyCustomFormField] with an custom field and controller.
///
/// ```dart
/// EasyCustomFormField<Color, ColorFieldController>(
///   name: 'color',
///   initialValue: Colors.teal,
///   controllerBuilder: (value) => ColorFieldController(value),
///   builder: (fieldState, onChangedHandler) => ColorField(
///     controller: fieldState.controller,
///     onChange: onChangedHandler,
///   ),
/// )
/// ```
///
/// Creates a [TextField] on the fly.
///
/// ```dart
/// EasyCustomFormField<String, TextEditingController>(
///   name: 'first_name',
///   initialValue: 'some text',
///   controllerBuilder: (value) => TextEditingController(text: value),
///   controllerRebuilder: (oldController) => TextEditingController.fromValue(oldController.value),
///   valueGet: (controller) => controller.text,
///   valueSet: (controller, newText) => controller.text = newText,
///   builder: (fieldState, onChangedHandler) => TextField(
///     controller: fieldState.controller,
///     focusNode: fieldState.focusNode,
///     decoration: InputDecoration(
///       errorText: fieldState.errorText,
///     ),
///     onChanged: onChangedHandler,
///   ),
///   validator: (value) => value.isEmpty ? 'Field is required.' : null,
/// ),
/// ```
///
/// See also:
///
///  * <https://material.io/design/components/text-fields.html>
///  * [TextField], which is the underlying text field without the [Form]
///    integration.
///  * Learn how to use a [Controller] in one of our [cookbook recipes](https://flutter.dev/docs/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller).
class EasyCustomFormField<T, C extends ValueNotifier>
    extends EasyFormField<T?> {
  /// Creates a [EasyCustomFormField] that contains a custom field.
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [Controller]
  /// will be constructed automatically and its value will be initialized
  /// to [initialValue] or the empty value.
  ///
  EasyCustomFormField({
    Key? key,
    required String name,
    this.controller,
    T? initialValue,
    required this.controllerBuilder,
    this.controllerRebuilder,
    this.valueGet,
    this.valueSet,
    required EasyFormCustomFieldBuilder<T, C> builder,
    ValueChanged<T>? onChanged,
    FormFieldSetter<T>? onSaved,
    EasyFormFieldValidator<T?>? validator,
    bool enabled = true,
    EasyAutovalidateMode autovalidateMode = EasyAutovalidateMode.disabled,
  })  : assert(initialValue == null || controller == null),
        super(
          key: key,
          name: name,
          initialValue:
              controller != null ? controller.value : (initialValue ?? null),
          onSaved: onSaved,
          validator: validator,
          enabled: enabled,
          autovalidateMode: autovalidateMode,
          builder: (EasyFormFieldState<T?> field) {
            final _EasyCustomFormFieldState<T, C> state =
                field as _EasyCustomFormFieldState<T, C>;
            void onChangedHandler(T value) {
              if (onChanged != null) {
                onChanged(value);
              }
              field.didChange(value);
            }

            return builder(state, onChangedHandler);
          },
        );

  /// Controls the value being edited.
  ///
  /// If null, this widget will create its own [Controller] and
  /// initialize its [Controller.value] with [initialValue].
  final C? controller;

  /// A builder that instantiates a controller of type `C` for a value of type `T`.
  ///
  /// Used to create a field on the fly in the widget tree.
  /// For a widget inheriting from `EasyCustomFormField`, override
  /// the `createController` method instead of using this builder.
  final CreateControllerCallback<C, T?> controllerBuilder;

  /// A builder that recreates a controller from an old controller,
  /// if not specified, the `controllerBuilder` builder will be used.
  ///
  /// Useful when using the [TextEditingController.fromValue] constructor
  /// to keep the caret position.
  /// ```dart
  /// controllerRebuilder: (oldController) => TextEditingController.fromValue(oldController.value),
  /// ```
  ///
  /// Used to create a field on the fly in the widget tree.
  /// For a widget inheriting from `EasyCustomFormField`, override
  /// the `recreateController` method instead of using this builder.
  final RecreateControllerCallback<C>? controllerRebuilder;

  /// Callback to get the value from the controller, if not set
  /// then the controller's `value` property is used.
  ///
  /// For example used for [TextEditingController] to get
  /// the value from the `text` property.
  /// ```dart
  /// valueGet: (controller) => controller.text,
  /// ```
  final ValueOfGetter<T?, C>? valueGet;

  /// Callback to set controller value, if not set - controller's
  /// `value` property is used.
  ///
  /// For example used for [TextEditingController] to set
  /// the value of the `text` property.
  /// ```dart
  /// valueSet: (controller, newText) => controller.text = newText,
  /// ```
  final ValueOfSetter<T?, C>? valueSet;

  /// A builder that instantiates a controller of type `C` for
  /// a value of type `T`.
  ///
  /// Calls the `controllerBuilder` callback by default.
  /// Can be overridden in a descendant for custom implementation.
  C createController(T value) => controllerBuilder(value);

  /// A builder that recreates a controller from an old controller.
  ///
  /// By default, it calls the `controllerRebuilder` callback or,
  /// if not defined, it calls the `controllerBuilder`.
  /// Can be overridden in a descendant for custom implementation.
  C recreateController(C oldController) =>
      controllerRebuilder?.call(oldController) ??
      controllerBuilder(oldController.value);

  /// Getter, to get the value from the controller.
  ///
  /// By default, it calls the `valueGet` callback, if not defined,
  /// it returns the controller's `value` property.
  T? valueOf(C controller) => valueGet?.call(controller) ?? controller.value;

  /// Setter, to set the controller value.
  ///
  /// By default, it calls the `valueSet` callback, if not defined,
  /// it sets the `value` property of the controller.
  setValue(C controller, T? value) {
    if (valueSet != null) {
      valueSet!.call(controller, value);
    } else {
      controller.value = value;
    }
  }

  @override
  _EasyCustomFormFieldState<T, C> createState() =>
      _EasyCustomFormFieldState<T, C>();
}

class _EasyCustomFormFieldState<T, C extends ValueNotifier>
    extends EasyFormFieldState<T?> {
  C? _controller;

  C get controller => widget.controller ?? _controller!;

  @override
  EasyCustomFormField<T?, C> get widget =>
      super.widget as EasyCustomFormField<T?, C>;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = widget.createController(widget.initialValue);
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(EasyCustomFormField<T?, C> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller = widget.recreateController(oldWidget.controller!);
      }
      if (widget.controller != null) {
        setValue(widget.valueOf(widget.controller!));
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(T? value) {
    super.didChange(value);

    final T? oldValue = widget.valueOf(controller);
    if (oldValue != value) widget.setValue(controller, value);
  }

  @override
  void resetValue() {
    super.resetValue();
    widget.setValue(controller, widget.initialValue);
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    final T? oldValue = widget.valueOf(controller);
    if (oldValue != value) didChange(oldValue);
  }
}
