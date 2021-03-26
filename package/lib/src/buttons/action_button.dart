import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../easy_form.dart';

/// Signature to invoke button action
typedef EasyFormButtonAction = void Function(
    BuildContext context, EasyFormState form);

/// Signature for building a button directly
typedef EasyFormActionButtonBuilder = Widget Function(
    BuildContext context,
    Key? key,
    Widget child,
    VoidCallback onPressed,
    EasyFormAdaptivity adaptivity);

/// Base class for [EasyForm] buttons that self-lock on form save.
///
/// A wrapper widget that builds a button using the `builder`
/// argument and locks the button when the form is saved
/// until the save is complete. Locking can be disabled
/// using the `blockOnSaving` parameter.
///
/// The `child` of the button is aligned with
/// the `alignment` argument (default `Alignment.center`)
/// and padded with the `padding` argument (default `8.0`).
///
/// The action when the button is pressed is determined
/// by the `action` argument.
class EasyFormActionButton extends StatelessWidget {
  /// Default padding inside a button
  static const EdgeInsetsGeometry kPadding = const EdgeInsets.all(8.0);

  /// Typically the button's label.
  final Widget child;

  /// The action when the button is pressed.
  final EasyFormButtonAction? action;

  /// Padding inside a button.
  final EdgeInsetsGeometry padding;

  /// Aligning content inside a button.
  final Alignment alignment;

  /// Whether to lock button press on form save.
  final bool lockOnSaving;

  final EasyFormActionButtonBuilder? _builder;

  /// Creates a widget that creates a form button.
  const EasyFormActionButton({
    Key? key,
    required this.child,
    this.action,
    EasyFormActionButtonBuilder? builder,
    this.padding = kPadding,
    this.alignment = Alignment.center,
    this.lockOnSaving = true,
  })  : _builder = builder,
        super(key: key);

  @protected
  Widget bodyBuilder(
      BuildContext context, Widget child, bool isSaving, EasyFormState form) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        widthFactor: 1,
        child: child,
      ),
    );
  }

  /// Calls an action when a button is pressed.
  void handleAction(BuildContext context, EasyFormState form) {
    action?.call(context, form);
  }

  @override
  Widget build(BuildContext context) {
    final form = EasyForm.of(context);
    if (form == null) return const SizedBox();

    return ValueListenableBuilder<bool>(
      valueListenable: form.isSaving,
      builder: (context, isSaving, _) {
        final Widget body = bodyBuilder(context, child, isSaving, form);
        final Widget button = (builder ?? defaultBuilder).call(context, key,
            body, () => handleAction(context, form), form.adaptivity);
        return IgnorePointer(
          ignoring: lockOnSaving ? isSaving : false,
          child: button,
        );
      },
    );
  }

  // Default builder

  /// Returns the button builder.
  @protected
  EasyFormActionButtonBuilder? get builder => _builder;

  /// The default button builder, creates an [ElevatedButton]
  /// or [CupertinoButton.filled].
  ///
  /// You can reassign to your builder globally so that you
  /// don't pass the builder function every time
  /// you create a widget.
  static EasyFormActionButtonBuilder defaultBuilder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, Key? key, Widget child,
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
        return ElevatedButton(
          key: key,
          child: child,
          onPressed: onPressed,
        );
    }
  }
}
