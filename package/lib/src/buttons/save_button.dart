import 'package:flutter/material.dart';
import 'action_button.dart';
import '../easy_form.dart';

typedef EasyFormSaveButtonIndicatorBuilder = Widget Function(BuildContext context, Size size);
typedef EasyFormSaveButtonLayoutBuilder = Widget Function(BuildContext context, Widget body, Widget indicator);

class EasyFormSaveButton extends EasyFormActionButton {
  static const Size kIndicatorSize = const Size(18, 18);

  final Size indicatorSize;
  final EasyFormSaveButtonIndicatorBuilder _indicatorBuilder;
  final EasyFormSaveButtonLayoutBuilder _layoutBuilder;

  const EasyFormSaveButton({
    Key key,
    @required Widget child,
    this.indicatorSize = kIndicatorSize,
    EasyFormSaveButtonIndicatorBuilder indicatorBuilder,
    EasyFormActionButtonBuilder builder,
    EdgeInsetsGeometry padding = EasyFormActionButton.kPadding,
    Alignment alignment = Alignment.center,
    EasyFormSaveButtonLayoutBuilder layoutBuilder,
  })  : assert(indicatorSize != null),
        _indicatorBuilder = indicatorBuilder,
        _layoutBuilder = layoutBuilder,
        super(
          key: key,
          child: child,
          builder: builder,
          padding: padding,
          alignment: alignment,
        );

  factory EasyFormSaveButton.text(
    String text, {
    Size indicatorSize = kIndicatorSize,
    EasyFormSaveButtonIndicatorBuilder indicatorBuilder,
    EasyFormActionButtonBuilder builder,
    EdgeInsetsGeometry padding = EasyFormActionButton.kPadding,
    Alignment alignment = Alignment.center,
    EasyFormSaveButtonLayoutBuilder layoutBuilder,
  }) {
    return EasyFormSaveButton(
      child: Text(text),
      indicatorSize: indicatorSize,
      indicatorBuilder: indicatorBuilder,
      builder: builder,
      padding: padding,
      alignment: alignment,
      layoutBuilder: layoutBuilder,
    );
  }

  @protected
  EasyFormSaveButtonIndicatorBuilder get indicatorBuilder => _indicatorBuilder ?? defaultIndicatorBuilder;

  @protected
  EasyFormSaveButtonLayoutBuilder get layoutBuilder => _layoutBuilder ?? defaultLayoutBuilder;

  @override
  void handleAction(BuildContext context, EasyFormState form) {
    form.save();
  }

  @override
  Widget bodyBuilder(BuildContext context, Widget child, bool isSaving) {
    final Widget body = super.bodyBuilder(context, child, isSaving);
    final Widget layout = layoutBuilder(
      context,
      isSaving ? Opacity(child: body, opacity: 0) : body,
      isSaving ? indicatorBuilder?.call(context, indicatorSize) : SizedBox.fromSize(size: indicatorSize),
    );

    return layout;
  }

  // Default builders

  static EasyFormSaveButtonLayoutBuilder defaultLayoutBuilder = _defaultLayoutBuilder;

  static Widget _defaultLayoutBuilder(BuildContext context, Widget body, Widget indicator) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        body,
        Positioned.fill(
          child: Center(
            child: indicator,
          ),
        ),
      ],
    );
  }

  static EasyFormSaveButtonIndicatorBuilder defaultIndicatorBuilder = _defaultIndicatorBuilder;

  static Widget _defaultIndicatorBuilder(BuildContext context, Size size) {
    final ThemeData theme = Theme.of(context);
    final Color color = theme?.colorScheme?.onPrimary;
    return SizedBox(
      width: size.width,
      height: size.height,
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
}

/*
enum EasyFormButtonState {
  normal,
  indicator,
}

typedef EasyFormSaveButtonBuilder = Widget Function(
    BuildContext context, Widget child, VoidCallback onPressed, EasyFormSaveButton button);
typedef EasyFormSaveButtonIndicatorBuilder = Widget Function(BuildContext context, EasyFormSaveButton button);
typedef EasyFormSaveButtonLayoutBuilder = Widget Function(BuildContext context, Widget body, Widget indicator);

class EasyFormSaveButton extends StatelessWidget {
  static const Size kIndicatorSize = const Size(18, 18);

  static const EdgeInsetsGeometry kPadding = const EdgeInsets.all(8.0);

  final Widget child;
  final Widget indicator;
  final EdgeInsetsGeometry padding;
  final Size indicatorSize;
  final EasyFormSaveButtonBuilder builder;

  const EasyFormSaveButton({
    Key key,
    @required this.child,
    this.builder,
    this.indicator,
    this.indicatorSize = kIndicatorSize,
    this.padding = kPadding,
  })  : assert(child != null),
        assert(indicatorSize != null),
        super(key: key);

  factory EasyFormSaveButton.text(
    String text, {
    Key key,
    EasyFormSaveButtonBuilder builder,
    Widget indicator,
    Size indicatorSize = kIndicatorSize,
    EdgeInsetsGeometry padding = kPadding,
  }) {
    return EasyFormSaveButton(
      key: key,
      child: Text(text),
      indicator: indicator,
      indicatorSize: indicatorSize,
      builder: builder,
      padding: padding,
    );
  }

  Widget _bodyBuilder(BuildContext context, Widget child) {
    return Padding(
      padding: padding,
      child: Center(
        child: child,
      ),
    );
  }

  static EasyFormSaveButtonLayoutBuilder defaultLayoutBuilder = _defaultLayoutBuilder;

  static Widget _defaultLayoutBuilder(BuildContext context, Widget body, Widget indicator) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        body,
        Positioned.fill(
          child: Center(
            child: indicator,
          ),
        ),
      ],
    );
  }

  static EasyFormSaveButtonBuilder defaultBuilder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, Widget child, VoidCallback onPressed, EasyFormSaveButton button) {
    return ElevatedButton(
      key: button.key,
      child: child,
      onPressed: onPressed,
    );
  }

  static EasyFormSaveButtonIndicatorBuilder defaultIndicatorBuilder = _defaultIndicatorBuilder;

  static Widget _defaultIndicatorBuilder(BuildContext context, EasyFormSaveButton button) {
    final ThemeData theme = Theme.of(context);
    final Color color = theme?.colorScheme?.onPrimary;
    return SizedBox(
      width: button.indicatorSize.width,
      height: button.indicatorSize.height,
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

  @override
  Widget build(BuildContext context) {
    final form = EasyForm.of(context);
    return ValueListenableBuilder(
      valueListenable: form.isSaving,
      builder: (context, isSaving, _) {
        final Widget body = _bodyBuilder(context, child);
        final Widget layout = defaultLayoutBuilder(
          context,
          isSaving ? Opacity(child: body, opacity: 0) : body,
          isSaving ? (indicator ?? defaultIndicatorBuilder(context, this)) : SizedBox.fromSize(size: indicatorSize),
        );
        final Widget button = (builder ?? defaultBuilder)?.call(context, layout, form.save, this) ?? const SizedBox();
        return IgnorePointer(
          ignoring: isSaving,
          child: button,
        );
      },
    );
  }
}
*/

/*
enum EasyFormButtonState {
  normal,
  indicator,
}

typedef EasyFormSaveButtonBuilder = Widget Function(
    BuildContext context, Widget child, VoidCallback onPressed, EasyFormSaveButton button);
typedef EasyFormSaveButtonIndicatorBuilder = Widget Function(BuildContext context, EasyFormSaveButton button);

class EasyFormSaveButton extends StatelessWidget {
  static const Size kMinimumSize = const Size(48, 18);
  // static const double kMinWidth = 18;
  // static const double kMinHeight = 18;
  static const EdgeInsetsGeometry kPadding = const EdgeInsets.all(8.0);

  final Widget child;
  final Widget indicator;
  final EdgeInsetsGeometry padding;
  // final double minHeight;
  final Size minimumSize;
  final EasyFormSaveButtonBuilder builder;

  const EasyFormSaveButton({
    Key key,
    @required this.child,
    this.builder,
    this.indicator,
    // this.minHeight = kMinHeight,
    this.minimumSize = kMinimumSize,
    this.padding = kPadding,
  })  : assert(child != null),
        // assert(minHeight != null),
        assert(minimumSize != null),
        super(key: key);

  factory EasyFormSaveButton.text(
    String text, {
    Key key,
    EasyFormSaveButtonBuilder builder,
    Widget indicator,
    EdgeInsetsGeometry padding = kPadding,
    // double minHeight = kMinHeight,
    Size minimumSize = kMinimumSize,
  }) {
    return EasyFormSaveButton(
      key: key,
      child: Text(text),
      indicator: indicator,
      builder: builder,
      padding: padding,
      // minHeight: minHeight,
      minimumSize: minimumSize,
    );
  }

  Widget _bodyBuilder(BuildContext context, Widget child) {
    return Padding(
      padding: padding,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minimumSize.width,
          minHeight: minimumSize.height,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }

  static EasyFormSaveButtonBuilder defaultBuilder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, Widget child, VoidCallback onPressed, EasyFormSaveButton button) {
    return ElevatedButton(
      key: button.key,
      child: child,
      onPressed: onPressed,
    );
  }

  static EasyFormSaveButtonIndicatorBuilder defaultIndicatorBuilder = _defaultIndicatorBuilder;

  static Widget _defaultIndicatorBuilder(BuildContext context, EasyFormSaveButton button) {
    final ThemeData theme = Theme.of(context);
    final Color color = theme?.colorScheme?.onPrimary;
    return SizedBox(
      width: button.minimumSize.height,
      height: button.minimumSize.height,
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

  @override
  Widget build(BuildContext context) {
    final form = EasyForm.of(context);
    return ValueListenableBuilder(
      valueListenable: form.isSaving,
      builder: (context, isSaving, _) {
        final Widget content = isSaving ? (indicator ?? defaultIndicatorBuilder(context, this)) : child;
        final Widget body = _bodyBuilder(context, content);
        final Widget button = (builder ?? defaultBuilder)?.call(context, body, form.save, this) ?? const SizedBox();
        return IgnorePointer(
          ignoring: isSaving,
          child: button,
        );
      },
    );
  }
}
*/
