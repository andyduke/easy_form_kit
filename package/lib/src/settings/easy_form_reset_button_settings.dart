import 'package:easy_form_kit/src/buttons/action_button.dart';
import 'package:flutter/foundation.dart';

/// Sets default builders for [EasyFormResetButton].
@immutable
class EasyFormResetButtonSettings with Diagnosticable {
  /// The default button builder, creates an [OutlinedButton]
  /// or [CupertinoButton].
  final EasyFormActionButtonBuilder? builder;

  /// Creates default settings for [EasyFormResetButton].
  EasyFormResetButtonSettings({
    this.builder,
  });

  @override
  bool operator ==(covariant EasyFormResetButtonSettings other) =>
      (builder == other.builder);

  @override
  int get hashCode => builder.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<EasyFormActionButtonBuilder?>.has(
        'builder', builder));
  }
}
