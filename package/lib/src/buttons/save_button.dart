import 'package:easy_form_kit/src/easy_form_default_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_form_kit/src/buttons/action_button.dart';
import 'package:easy_form_kit/src/easy_form.dart';

/// Signature for the save indicator builder
typedef EasyFormSaveButtonIndicatorBuilder = Widget Function(
    BuildContext context, Size size, EasyFormAdaptivity adaptivity);

/// Signature for button content layout builder
typedef EasyFormSaveButtonLayoutBuilder = Widget Function(
    BuildContext context, Widget body, Widget indicator);

/// The builder of the button that, when pressed,
/// causes the form fields to be saved and shows
/// an indicator in the process of saving.
///
/// The widget has two constructors, the standard [EasyFormSaveButton],
/// in which you can specify any widget in the `child` argument as
/// the button content, and the [EasyFormSaveButton.text] constructor,
/// in which you can specify the text on the button.
///
/// See also:
///  * [EasyFormDefaultSettings], where the builders can be set globally.
///
class EasyFormSaveButton extends EasyFormActionButton {
  /// Default indicator size
  static const Size kIndicatorSize = const Size(18, 18);

  /// Indicator size
  final Size indicatorSize;

  final EasyFormSaveButtonIndicatorBuilder? _indicatorBuilder;
  final EasyFormSaveButtonLayoutBuilder? _layoutBuilder;

  /// Creates a widget that creates a form save button.
  const EasyFormSaveButton({
    Key? key,
    required Widget child,
    this.indicatorSize = kIndicatorSize,
    EasyFormSaveButtonIndicatorBuilder? indicatorBuilder,
    EasyFormActionButtonBuilder? builder,
    EdgeInsetsGeometry padding = EasyFormActionButton.kPadding,
    Alignment alignment = Alignment.center,
    EasyFormSaveButtonLayoutBuilder? layoutBuilder,
    bool enabled = true,
  })  : _indicatorBuilder = indicatorBuilder,
        _layoutBuilder = layoutBuilder,
        super(
          key: key,
          child: child,
          builder: builder,
          padding: padding,
          alignment: alignment,
          enabled: enabled,
        );

  /// Creates a widget that creates a form save button with text as a child.
  factory EasyFormSaveButton.text(
    String text, {
    Size indicatorSize = kIndicatorSize,
    EasyFormSaveButtonIndicatorBuilder? indicatorBuilder,
    EasyFormActionButtonBuilder? builder,
    EdgeInsetsGeometry padding = EasyFormActionButton.kPadding,
    Alignment alignment = Alignment.center,
    EasyFormSaveButtonLayoutBuilder? layoutBuilder,
    bool enabled = true,
  }) {
    return EasyFormSaveButton(
      child: Text(text),
      indicatorSize: indicatorSize,
      indicatorBuilder: indicatorBuilder,
      builder: builder,
      padding: padding,
      alignment: alignment,
      layoutBuilder: layoutBuilder,
      enabled: enabled,
    );
  }

  /// The builder of the indicator inside the button displayed
  /// during the save process.
  ///
  /// See also:
  ///
  ///  * [EasyFormDefaultSettings], where the indicator builder can be set globally.
  ///  * [defaultIndicatorBuilder], where the indicator builder can be set globally.
  @protected
  EasyFormSaveButtonIndicatorBuilder getIndicatorBuilder(
          BuildContext context) =>
      _indicatorBuilder ??
      EasyFormDefaultSettings.maybeOf(context)?.saveButton?.indicatorBuilder ??
      defaultIndicatorBuilder;

  /// Button content layout builder.
  ///
  /// See also:
  ///  * [EasyFormDefaultSettings], where the layout builder can be set globally.
  ///  * [defaultLayoutBuilder], where the layout builder can be set globally.
  @protected
  EasyFormSaveButtonLayoutBuilder getLayoutBuilder(BuildContext context) =>
      _layoutBuilder ??
      EasyFormDefaultSettings.maybeOf(context)?.saveButton?.layoutBuilder ??
      defaultLayoutBuilder;

  @override
  void handleAction(BuildContext context, EasyFormState form) {
    form.save();
  }

  @override
  Widget bodyBuilder(
      BuildContext context, Widget child, bool isSaving, EasyFormState form) {
    final Widget body = super.bodyBuilder(context, child, isSaving, form);
    final Widget layout = getLayoutBuilder(context).call(
      context,
      isSaving ? Opacity(child: body, opacity: 0) : body,
      isSaving
          ? getIndicatorBuilder(context)
              .call(context, indicatorSize, form.adaptivity)
          : SizedBox.fromSize(size: indicatorSize),
    );

    return layout;
  }

  // Default builders

  @override
  EasyFormActionButtonBuilder getDefaultBuilder(BuildContext context) =>
      EasyFormDefaultSettings.maybeOf(context)?.saveButton?.builder ??
      super.getDefaultBuilder(context) ??
      defaultBuilder;

  /// The default button builder, creates an [ElevatedButton] or [CupertinoButton.filled].
  /// You can reassign to your builder globally so that you
  /// don't pass the builder function every time
  /// you create a widget.
  ///
  /// See also:
  ///  * [EasyFormDefaultSettings], where the builder can be set globally.
  ///  * [EasyFormActionButton.defaultBuilder] which is the default.
  ///
  static EasyFormActionButtonBuilder defaultBuilder =
      EasyFormActionButton.defaultBuilder;

  /// The default button content layout builder.
  ///
  /// You can reassign to your builder globally so that you
  /// don't pass the builder function every time
  /// you create a widget.
  ///
  /// By default, this is a [Stack] with a centered indicator
  /// on top of the button's content.
  ///
  /// See also:
  ///  * [EasyFormDefaultSettings], where the layout builder can be set globally.
  ///
  static EasyFormSaveButtonLayoutBuilder defaultLayoutBuilder =
      _defaultLayoutBuilder;

  static Widget _defaultLayoutBuilder(
      BuildContext context, Widget body, Widget indicator) {
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

  /// Default constructor for button indicator on save.
  ///
  /// You can reassign to your builder globally so that you
  /// don't pass the builder function every time
  /// you create a widget.
  ///
  /// By default, this is a [CircularProgressIndicator] or [CupertinoActivityIndicator] with
  /// a size of 18x18 and the color of the text from the [ElevatedButton].
  static EasyFormSaveButtonIndicatorBuilder defaultIndicatorBuilder =
      _defaultIndicatorBuilder;

  static Widget _defaultIndicatorBuilder(
      BuildContext context, Size size, EasyFormAdaptivity adaptivity) {
    final ThemeData theme = Theme.of(context);
    final Color? color =
        theme.buttonTheme.colorScheme?.primary ?? theme.colorScheme.onPrimary;

    Widget indicator;
    switch (adaptivity) {
      case EasyFormAdaptivity.cupertino:
        indicator = CupertinoActivityIndicator();
        break;

      case EasyFormAdaptivity.auto:
      case EasyFormAdaptivity.material:
      default:
        indicator = CircularProgressIndicator(
          strokeWidth: 2,
          color: color,
        );
        break;
    }

    return SizedBox.fromSize(
      size: size,
      child: Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(secondary: color),
        ),
        child: indicator,
      ),
    );
  }
}
