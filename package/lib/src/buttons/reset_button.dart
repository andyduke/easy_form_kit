import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'action_button.dart';
import '../easy_form.dart';

/// The button builder that, when pressed, clears the data
/// of the form fields, returning them to their initial values.
///
/// The widget has two constructors, the standard [EasyFormResetButton],
/// in which you can specify any widget in the `child` argument as
/// the button content, and the [EasyFormResetButton.text] constructor,
/// in which you can specify the text on the button.
///
/// See also:
///
///  * [EasyFormActionButton], basic widget for EasyForm form buttons.
class EasyFormResetButton extends EasyFormActionButton {
  /// Creates a widget that creates a form reset button.
  const EasyFormResetButton({
    Key key,
    @required Widget child,
    EasyFormActionButtonBuilder builder,
    EdgeInsetsGeometry padding = EasyFormActionButton.kPadding,
    Alignment alignment = Alignment.center,
  }) : super(
          key: key,
          child: child,
          builder: builder,
          padding: padding,
          alignment: alignment,
        );

  /// Creates a widget that creates a form reset button with text as a child.
  factory EasyFormResetButton.text(
    String text, {
    EasyFormActionButtonBuilder builder,
    EdgeInsetsGeometry padding = EasyFormActionButton.kPadding,
    Alignment alignment = Alignment.center,
  }) {
    return EasyFormResetButton(
      child: Text(text),
      builder: builder,
      padding: padding,
      alignment: alignment,
    );
  }

  @override
  void handleAction(BuildContext context, EasyFormState form) {
    form.reset();
  }

  // Default builder

  @override
  EasyFormActionButtonBuilder get builder => super.builder ?? defaultBuilder;

  /// The default button builder, creates an [OutlinedButton]
  /// or [CupertinoButton].
  ///
  /// You can reassign to your builder globally so that you
  /// don't pass the builder function every time
  /// you create a widget.
  static EasyFormActionButtonBuilder defaultBuilder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, Key key, Widget child,
      VoidCallback onPressed, EasyFormAdaptivity adaptivity) {
    switch (adaptivity) {
      case EasyFormAdaptivity.cupertino:
        return CupertinoButton(
          key: key,
          child: child,
          onPressed: onPressed,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        );

      case EasyFormAdaptivity.auto:
      case EasyFormAdaptivity.material:
      default:
        return OutlinedButton(
          key: key,
          child: child,
          onPressed: onPressed,
        );
    }
  }
}
