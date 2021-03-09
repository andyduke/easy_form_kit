import 'package:flutter/material.dart';
import 'action_button.dart';
import '../easy_form.dart';

class EasyFormResetButton extends EasyFormActionButton {
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
  EasyFormActionButtonBuilder get builder => super.builder ?? _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, Key key, Widget child, VoidCallback onPressed) {
    return OutlinedButton(
      key: key,
      child: child,
      onPressed: onPressed,
    );
  }
}
