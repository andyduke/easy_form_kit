import 'package:flutter/material.dart';
import '../easy_form.dart';

/// Button builder signature
typedef EasyFormButtonBuilder = Widget Function(
    BuildContext context, EasyFormState form);

/// Builder widget that passes a link to the [EasyFormState] to the `builder`.
///
/// A convenient widget for accessing form methods such as `save`, `reset`, `validate`.
/// ```dart
/// EasyFormButton(
///   builder: (context, form) => OutlinedButton(
///     child: Text('Clear form data'),
///     onPressed: () => form.reset(),
///   ),
/// )
/// ```
class EasyFormButton extends StatelessWidget {
  /// Called to build the button itself.
  final EasyFormButtonBuilder builder;

  /// Creates a widget that creates a form button.
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
