import 'package:flutter/material.dart';
import '../easy_form.dart';

typedef EasyFormButtonBuilder = Widget Function(BuildContext context, EasyFormState form);

class EasyFormButton extends StatelessWidget {
  final EasyFormButtonBuilder builder;

  const EasyFormButton({
    Key key,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, EasyForm.of(context));
  }
}

/*
enum EasyFormButtonState {
  normal,
  indicator,
}

typedef EasyFormButtonBuilder = Widget Function(
    BuildContext context, Widget child, VoidCallback onPressed, EasyFormButton button);
typedef EasyFormButtonIndicatorBuilder = Widget Function(BuildContext context, EasyFormButton button);

class EasyFormButton {
  static const double kMinHeight = 18;
  static const EdgeInsetsGeometry kPadding = const EdgeInsets.all(8.0);

  final Key key;
  final Widget child;
  final Widget indicator;
  final EdgeInsetsGeometry padding;
  final double minHeight;
  final EasyFormButtonBuilder builder;

  const EasyFormButton({
    this.key,
    @required this.child,
    this.builder,
    this.indicator,
    this.padding = kPadding,
    this.minHeight = kMinHeight,
  })  : assert(child != null),
        assert(minHeight != null);

  factory EasyFormButton.text(
    String text, {
    Key key,
    EasyFormButtonBuilder builder,
    Widget indicator,
    EdgeInsetsGeometry padding = kPadding,
    double minHeight = kMinHeight,
  }) {
    return EasyFormButton(
      key: key,
      child: Text(text),
      indicator: indicator,
      builder: builder,
      padding: padding,
      minHeight: minHeight,
    );
  }

  static EasyFormButtonBuilder defaultBuilder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, Widget child, VoidCallback onPressed, EasyFormButton button) {
    return ElevatedButton(
      key: button.key,
      child: Padding(
        padding: button.padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: button.minHeight,
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }

  static EasyFormButtonIndicatorBuilder defaultIndicatorBuilder = _defaultIndicatorBuilder;

  static Widget _defaultIndicatorBuilder(BuildContext context, EasyFormButton button) {
    final ThemeData theme = Theme.of(context);
    final Color color = theme?.colorScheme?.onPrimary;
    return SizedBox(
      width: button.minHeight,
      height: button.minHeight,
      child: Theme(
        data: theme.copyWith(
          accentColor: color,
        ),
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget build(BuildContext context, EasyFormButtonState state, VoidCallback onPressed) {
    final Widget body =
        (state == EasyFormButtonState.normal) ? child : (indicator ?? defaultIndicatorBuilder(context, this));
    return (builder ?? defaultBuilder)?.call(context, body, onPressed, this) ?? const SizedBox();
  }
}
*/
