import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'easy_form.dart';
import 'custom_form_field.dart';

export 'package:flutter/services.dart' show SmartQuotesType, SmartDashesType;

/// A [EasyCustomFormField] that contains a [TextField].
///
/// This is a convenience widget that wraps a [TextField] widget in a
/// [EasyCustomFormField].
///
/// When a [controller] is specified, its [TextEditingController.text]
/// defines the [initialValue]. If this [EasyTextFormField] is part of a scrolling
/// container that lazily constructs its children, like a [ListView] or a
/// [CustomScrollView], then a [controller] should be specified.
/// The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container.
///
/// If a [controller] is not specified, [initialValue] can be used to give
/// the automatically generated controller an initial value.
///
/// Remember to call [TextEditingController.dispose] of the [TextEditingController]
/// when it is no longer needed. This will ensure we discard any resources used
/// by the object.
///
/// By default, `decoration` will apply the [ThemeData.inputDecorationTheme] for
/// the current context to the [InputDecoration], see
/// [InputDecoration.applyDefaults].
///
/// For a documentation about the various parameters, see [TextField].
///
/// Creates a [EasyTextFormField] with an [InputDecoration] and validator function.
///
/// ![If the user enters valid text, the TextField appears normally without any warnings to the user](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field.png)
///
/// ![If the user enters invalid text, the error message returned from the validator function is displayed in dark red underneath the input](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field_error.png)
///
/// ```dart
/// EasyTextFormField(
///   name: 'name',
///   decoration: const InputDecoration(
///     icon: Icon(Icons.person),
///     hintText: 'What do people call you?',
///     labelText: 'Name *',
///   ),
///   validator: (String value) {
///     return value.contains('@') ? 'Do not use the @ char.' : null;
///   },
/// )
/// ```
///
/// See also:
///
///  * <https://material.io/design/components/text-fields.html>
///  * [TextField], which is the underlying text field without the [EasyForm]
///    integration.
///  * [InputDecorator], which shows the labels and other visual elements that
///    surround the actual text editing widget.
///  * Learn how to use a [TextEditingController] in one of our [cookbook recipes](https://flutter.dev/docs/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller).
class EasyTextFormField
    extends EasyCustomFormField<String, TextEditingController> {
  /// Creates a [EasyCustomFormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [new TextField], the constructor.
  EasyTextFormField({
    Key? key,
    required String name,
    TextEditingController? controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    EasyFormFieldValidator<String?>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    EasyAutovalidateMode autovalidateMode = EasyAutovalidateMode.disabled,
    bool saveOnSubmit = false,
  }) : super(
          key: key,
          name: name,
          controller: controller,
          focusNode: focusNode,
          initialValue: initialValue ?? '',
          controllerBuilder: (value) => TextEditingController(text: value),
          controllerRebuilder: (oldController) =>
              TextEditingController.fromValue(oldController.value),
          valueGet: (controller) => controller.text,
          valueSet: (controller, value) => controller.text = value ?? '',
          builder: (state, onChangedHandler) {
            final InputDecoration effectiveDecoration = decoration
                .applyDefaults(Theme.of(state.context).inputDecorationTheme);
            return TextField(
              controller: state.controller as TextEditingController?,
              focusNode: state.focusNode,
              decoration:
                  effectiveDecoration.copyWith(errorText: state.errorText),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              textDirection: textDirection,
              textCapitalization: textCapitalization,
              autofocus: autofocus,
              toolbarOptions: toolbarOptions,
              readOnly: readOnly,
              showCursor: showCursor,
              obscuringCharacter: obscuringCharacter,
              obscureText: obscureText,
              autocorrect: autocorrect,
              smartDashesType: smartDashesType ??
                  (obscureText
                      ? SmartDashesType.disabled
                      : SmartDashesType.enabled),
              smartQuotesType: smartQuotesType ??
                  (obscureText
                      ? SmartQuotesType.disabled
                      : SmartQuotesType.enabled),
              enableSuggestions: enableSuggestions,
              maxLengthEnforcement: maxLengthEnforcement,
              maxLines: maxLines,
              minLines: minLines,
              expands: expands,
              maxLength: maxLength,
              onChanged: onChangedHandler,
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              onSubmitted: (value) {
                onFieldSubmitted?.call(value);
                if (saveOnSubmit) state.saveForm();
              },
              inputFormatters: inputFormatters,
              enabled: enabled,
              cursorWidth: cursorWidth,
              cursorHeight: cursorHeight,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              scrollPhysics: scrollPhysics,
              keyboardAppearance: keyboardAppearance,
              enableInteractiveSelection: enableInteractiveSelection,
              buildCounter: buildCounter,
              autofillHints: autofillHints,
            );
          },
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled,
          autovalidateMode: autovalidateMode,
        );

  /// Creates [EasyCustomFormField], which builds [TextField] using a builder.
  ///
  /// See also:
  ///
  ///  * [EasyTextFormField], default constructor.
  ///
  EasyTextFormField.builder({
    Key? key,
    required String name,
    required EasyFormCustomFieldBuilder<String, TextEditingController> builder,
    TextEditingController? controller,
    String? initialValue,
    ValueChanged<String>? onChanged,
    FormFieldSetter<String>? onSaved,
    EasyFormFieldValidator<String?>? validator,
    bool enabled = true,
    EasyAutovalidateMode autovalidateMode = EasyAutovalidateMode.disabled,
  }) : super(
          key: key,
          name: name,
          controller: controller,
          initialValue: initialValue ?? '',
          controllerBuilder: (value) => TextEditingController(text: value),
          controllerRebuilder: (oldController) =>
              TextEditingController.fromValue(oldController.value),
          valueGet: (controller) => controller.text,
          valueSet: (controller, value) => controller.text = value ?? '',
          builder: builder,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled,
          autovalidateMode: autovalidateMode,
        );
}
