import 'package:easy_form_kit/src/easy_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Signature for the save indicator builder
typedef EasyFormSaveIndicatorBuilder = Widget Function(
    BuildContext context, Size size, EasyFormAdaptivity adaptivity);

/// Signature for the save indicator layout builder
typedef EasyFormSaveIndicatorLayoutBuilder = Widget
    Function(BuildContext context, Widget body, [Widget indicator]);

/// Form save indicator builder.
///
/// Shows a save indicator on top of its `child` and blocks
/// pressing on it while the form is being saved.
///
/// Must be located inside [EasyForm].
///
/// ```dart
/// EasyForm(
///   child: EasyFormSaveIndicator(
///     child: Column(
///       children: [
///         EasyTextFormField(...),
///         ...
///       ],
///     ),
///   ),
/// ),
/// ```
class EasyFormSaveIndicator extends StatelessWidget {
  /// Default indicator size
  static const Size kIndicatorSize = const Size.square(32);

  /// Default opacity of the child widget while the form
  /// is being saved
  static const double kChildOpacityOnSave = 0.5;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The opacity of the child widget while the form
  /// is being saved (default 0.5).
  final double childOpacityOnSave;

  /// The builder of the indicator on top of a child, displayed
  /// during the save process.
  final EasyFormSaveIndicatorBuilder indicatorBuilder;

  /// Indicator size
  final Size indicatorSize;

  /// Indicator layout builder
  final EasyFormSaveIndicatorLayoutBuilder layoutBuilder;

  /// Creates a form save indicator widget.
  const EasyFormSaveIndicator({
    Key key,
    @required this.child,
    this.childOpacityOnSave = kChildOpacityOnSave,
    this.indicatorBuilder,
    this.indicatorSize = kIndicatorSize,
    this.layoutBuilder,
  })  : assert(child != null),
        super(key: key);

  /// Default constructor for indicator on save.
  ///
  /// You can reassign to your builder globally so that you
  /// don't pass the builder function every time
  /// you create a widget.
  ///
  /// By default, this is a [CircularProgressIndicator] or [CupertinoActivityIndicator] with
  /// a size of 32x32.
  static EasyFormSaveIndicatorBuilder defaultIndicatorBuilder =
      _defaultIndicatorBuilder;

  static Widget _defaultIndicatorBuilder(
      BuildContext context, Size size, EasyFormAdaptivity adaptivity) {
    Widget indicator;

    switch (adaptivity) {
      case EasyFormAdaptivity.cupertino:
        indicator = CupertinoActivityIndicator();
        break;

      case EasyFormAdaptivity.auto:
      case EasyFormAdaptivity.material:
      default:
        indicator = CircularProgressIndicator(
          strokeWidth: 3,
        );
        break;
    }

    return SizedBox.fromSize(
      size: size,
      child: indicator,
    );
  }

  /// The default indicator layout builder.
  ///
  /// You can reassign to your builder globally so that you
  /// don't pass the builder function every time
  /// you create a widget.
  ///
  /// By default, this is a [Stack] with a centered indicator
  /// on top of the child.
  static EasyFormSaveIndicatorLayoutBuilder defaultLayoutBuilder =
      _defaultLayoutBuilder;

  static Widget _defaultLayoutBuilder(BuildContext context, Widget body,
      [Widget indicator]) {
    return Stack(
      alignment: Alignment.center,
      children: [
        body,
        if (indicator != null)
          Positioned.fill(
            child: Center(
              child: indicator,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final EasyFormState form = EasyForm.of(context);
    if (form == null) return child;

    return ValueListenableBuilder(
      valueListenable: form.isSaving,
      child: child,
      builder: (context, isSaving, body) {
        final Widget indicator = isSaving
            ? KeyedSubtree(
                key: ValueKey('save-indicator-overlay'),
                child: (indicatorBuilder ?? defaultIndicatorBuilder)
                    .call(context, indicatorSize, form.adaptivity),
              )
            : null;
        return (layoutBuilder ?? defaultLayoutBuilder).call(
          context,
          KeyedSubtree(
            key: ValueKey('save-indicator-child'),
            child: IgnorePointer(
              ignoring: isSaving,
              child: Opacity(
                  opacity: isSaving ? childOpacityOnSave : 1.0, child: body),
            ),
          ),
          indicator,
        );
      },
    );
  }
}
