import 'package:flutter/material.dart';
import '../easy_form.dart';

typedef EasyFormButtonAction = void Function(BuildContext context, EasyFormState form);
typedef EasyFormActionButtonBuilder = Widget Function(
    BuildContext context, Key key, Widget child, VoidCallback onPressed);

class EasyFormActionButton extends StatelessWidget {
  static const EdgeInsetsGeometry kPadding = const EdgeInsets.all(8.0);

  final Widget child;
  final EasyFormButtonAction action;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final EasyFormActionButtonBuilder _builder;
  final bool blockOnSaving;

  const EasyFormActionButton({
    Key key,
    @required this.child,
    this.action,
    EasyFormActionButtonBuilder builder,
    this.padding = kPadding,
    this.alignment = Alignment.center,
    this.blockOnSaving = true,
  })  : assert(child != null),
        assert(blockOnSaving != null),
        _builder = builder,
        super(key: key);

  @protected
  Widget bodyBuilder(BuildContext context, Widget child, bool isSaving) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        widthFactor: 1,
        child: child,
      ),
    );
  }

  void handleAction(BuildContext context, EasyFormState form) {
    action?.call(context, form);
  }

  @override
  Widget build(BuildContext context) {
    final form = EasyForm.of(context);
    return ValueListenableBuilder(
      valueListenable: form.isSaving,
      builder: (context, isSaving, _) {
        final Widget body = bodyBuilder(context, child, isSaving);
        final Widget button =
            (builder ?? defaultBuilder)?.call(context, key, body, () => handleAction(context, form)) ??
                const SizedBox();
        return IgnorePointer(
          ignoring: blockOnSaving ? isSaving : false,
          child: button,
        );
      },
    );
  }

  // Default builder

  @protected
  EasyFormActionButtonBuilder get builder => _builder;

  static EasyFormActionButtonBuilder defaultBuilder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, Key key, Widget child, VoidCallback onPressed) {
    return ElevatedButton(
      key: key,
      child: child,
      onPressed: onPressed,
    );
  }
}
