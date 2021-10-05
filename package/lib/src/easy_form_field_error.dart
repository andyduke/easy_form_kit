import 'package:easy_form_kit/src/easy_form.dart';
import 'package:flutter/widgets.dart';

/// Signature for the form field error displayer builder
typedef EasyFormFieldErrorBuilder = Widget Function(
    BuildContext context, String fieldName, String? errorText);

/// Widget for displaying a form field error.
///
/// If the form field contains an error, it displays it.
/// If there is no error, it shows nothing.
///
/// In the [builder], you can set your own error display handler.
/// By default, it is just [Text] with the specified style and alignment.
///
/// Must be located inside [EasyForm].
///
class EasyFormFieldError extends StatelessWidget {
  /// The name of the field for which to display the error
  final String name;

  /// Default style for error text
  final TextStyle? textStyle;

  /// Default alignment for error text
  final TextAlign? textAlign;

  /// Widget builder for error display
  final EasyFormFieldErrorBuilder? builder;

  /// Creates an error display widget.
  const EasyFormFieldError({
    Key? key,
    required this.name,
    this.textStyle,
    this.textAlign,
    this.builder,
  }) : super(key: key);

  /// The default constructor for the error display widget.
  ///
  /// You can reassign to your builder globally so that you
  /// don't pass the builder function every time
  /// you create a widget.
  ///
  /// By default, it is just [Text].
  static EasyFormFieldErrorBuilder defaultBuilder = _defaultBuilder;

  static Widget _defaultBuilder(
      BuildContext context, String fieldName, String? errorText) {
    final hasError = errorText?.isNotEmpty ?? false;

    return hasError ? Text(errorText!) : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final form = EasyForm.of(context);
    final errorText = form?.fieldError(name);

    return DefaultTextStyle.merge(
      style: textStyle,
      textAlign: textAlign,
      child: (builder ?? defaultBuilder).call(context, name, errorText),
    );
  }
}
