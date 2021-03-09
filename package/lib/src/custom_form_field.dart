import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'easy_form.dart';

export 'package:flutter/services.dart' show SmartQuotesType, SmartDashesType;

typedef CreateControllerCallback<C, T> = C Function(T value);
typedef RecreateControllerCallback<C> = C Function(C oldController);
typedef ValueOfGetter<T, C> = T Function(C controller);
typedef ValueOfSetter<T, C> = Function(C controller, T value);

typedef EasyFormCustomFieldChangeHandler<T> = void Function(T value);
typedef EasyFormCustomFieldBuilder<T, C> = Widget Function(
    _EasyCustomFormFieldState fieldState, EasyFormCustomFieldChangeHandler<T> onChangedHandler);

/// A [FormField] that contains a [TextField].
///
/// This is a convenience widget that wraps a [TextField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// When a [controller] is specified, its [Controller.value]
/// defines the [initialValue]. If this [FormField] is part of a scrolling
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
/// By default, `decoration` will apply the [ThemeData.inputDecorationTheme] for
/// the current context to the [InputDecoration], see
/// [InputDecoration.applyDefaults].
///
/// For a documentation about the various parameters, see [TextField].
///
/// {@tool snippet}
///
/// Creates a [EasyCustomFormField] with an [InputDecoration] and validator function.
///
/// ![If the user enters valid text, the TextField appears normally without any warnings to the user](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field.png)
///
/// ![If the user enters invalid text, the error message returned from the validator function is displayed in dark red underneath the input](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field_error.png)
///
/// ```dart
/// TextFormField(
///   decoration: const InputDecoration(
///     icon: Icon(Icons.person),
///     hintText: 'What do people call you?',
///     labelText: 'Name *',
///   ),
///   onSaved: (String value) {
///     // This optional block of code can be used to run
///     // code when the user saves the form.
///   },
///   validator: (String value) {
///     return value.contains('@') ? 'Do not use the @ char.' : null;
///   },
/// )
/// ```
/// {@end-tool}
///
/// {@tool dartpad --template=stateful_widget_material}
/// This example shows how to move the focus to the next field when the user
/// presses the SPACE key.
///
/// ```dart imports
/// import 'package:flutter/services.dart';
/// ```
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Material(
///     child: Center(
///       child: Shortcuts(
///         shortcuts: <LogicalKeySet, Intent>{
///           // Pressing space in the field will now move to the next field.
///           LogicalKeySet(LogicalKeyboardKey.space): const NextFocusIntent(),
///         },
///         child: FocusTraversalGroup(
///           child: Form(
///             autovalidateMode: EasyAutovalidateMode.always,
///             onChanged: () {
///               Form.of(primaryFocus.context).save();
///             },
///             child: Wrap(
///               children: List<Widget>.generate(5, (int index) {
///                 return Padding(
///                   padding: const EdgeInsets.all(8.0),
///                   child: ConstrainedBox(
///                     constraints: BoxConstraints.tight(const Size(200, 50)),
///                     child: TextFormField(
///                       onSaved: (String value) {
///                         print('Value for field $index saved as "$value"');
///                       },
///                     ),
///                   ),
///                 );
///               }),
///             ),
///           ),
///         ),
///       ),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * <https://material.io/design/components/text-fields.html>
///  * [TextField], which is the underlying text field without the [Form]
///    integration.
///  * [InputDecorator], which shows the labels and other visual elements that
///    surround the actual text editing widget.
///  * Learn how to use a [Controller] in one of our [cookbook recipes](https://flutter.dev/docs/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller).
class EasyCustomFormField<T, C extends ValueNotifier> extends EasyFormField<T> {
  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [Controller]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [new TextField], the constructor.
  EasyCustomFormField({
    Key key,
    @required String name,
    this.controller,
    T initialValue,
    @required this.controllerBuilder,
    this.controllerRebuilder,
    this.valueGet,
    this.valueSet,
    @required EasyFormCustomFieldBuilder<T, C> builder,
    FocusNode focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction,
    TextStyle style,
    StrutStyle strutStyle,
    TextDirection textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions toolbarOptions,
    bool showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType smartDashesType,
    SmartQuotesType smartQuotesType,
    bool enableSuggestions = true,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int minLines,
    bool expands = false,
    int maxLength,
    ValueChanged<T> onChanged,
    GestureTapCallback onTap,
    VoidCallback onEditingComplete,
    ValueChanged<T> onFieldSubmitted,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    List<TextInputFormatter> inputFormatters,
    bool enabled,
    double cursorWidth = 2.0,
    double cursorHeight,
    Radius cursorRadius,
    Color cursorColor,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder buildCounter,
    ScrollPhysics scrollPhysics,
    Iterable<String> autofillHints,
    EasyAutovalidateMode autovalidateMode = EasyAutovalidateMode.disabled,
  })  : assert(initialValue == null || controller == null),
        assert(textAlign != null),
        assert(autofocus != null),
        assert(readOnly != null),
        assert(obscuringCharacter != null && obscuringCharacter.length == 1),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(enableSuggestions != null),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(expands != null),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength > 0),
        assert(enableInteractiveSelection != null),
        super(
          key: key,
          name: name,
          initialValue: controller != null ? controller.value : (initialValue ?? null),
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode,
          builder: (EasyFormFieldState<T> field) {
            final _EasyCustomFormFieldState<T, C> state = field as _EasyCustomFormFieldState<T, C>;
            // final InputDecoration effectiveDecoration =
            //     (decoration ?? const InputDecoration()).applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(T value) {
              if (onChanged != null) {
                onChanged(value);
              }
              field.didChange(value);
            }

            return builder(state, onChangedHandler);
          },
        );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [Controller] and
  /// initialize its [Controller.value] with [initialValue].
  final C controller;

  final CreateControllerCallback<C, T> controllerBuilder;
  final RecreateControllerCallback<C> controllerRebuilder;

  final ValueOfGetter<T, C> valueGet;
  final ValueOfSetter<T, C> valueSet;

  C createController(T value) => controllerBuilder?.call(value);
  C recreateController(C oldController) => (controllerRebuilder != null)
      ? controllerRebuilder.call(oldController)
      : controllerBuilder?.call(oldController.value);

  T valueOf(C controller) => (valueGet != null) ? valueGet.call(controller) : controller.value;
  setValue(C controller, T value) => (valueSet != null) ? valueSet.call(controller, value) : controller.value = value;

  @override
  _EasyCustomFormFieldState<T, C> createState() => _EasyCustomFormFieldState<T, C>();
}

class _EasyCustomFormFieldState<T, C extends ValueNotifier> extends EasyFormFieldState<T> {
  C _controller;

  C get controller => widget.controller ?? _controller;

  @override
  EasyCustomFormField<T, C> get widget => super.widget as EasyCustomFormField<T, C>;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = widget.createController(widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(EasyCustomFormField<T, C> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = widget.recreateController(oldWidget.controller);
      if (widget.controller != null) {
        setValue(widget.valueOf(widget.controller));
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
  void didChange(T value) {
    super.didChange(value);

    final T oldValue = widget.valueOf(controller);
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
    final T oldValue = widget.valueOf(controller);
    if (oldValue != value) didChange(oldValue);
  }
}
