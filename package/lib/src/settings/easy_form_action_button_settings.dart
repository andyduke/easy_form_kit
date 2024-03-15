import 'package:easy_form_kit/src/buttons/action_button.dart';
import 'package:flutter/foundation.dart';

/// Sets default builders for [EasyFormActionButton].
@immutable
class EasyFormActionButtonSettings with Diagnosticable {
  /// Builder for [EasyForm] action button ([EasyFormActionButton]).
  ///
  /// It is also used in the [EasyFormSaveButton] and [EasyFormResetButton] buttons,
  /// if they do not have their own builder specified in the corresponding settings
  /// ([EasyFormSaveButtonSettings] and [EasyFormResetButtonSettings]).
  final EasyFormActionButtonBuilder? builder;

  /// Creates default settings for [EasyFormActionButton].
  EasyFormActionButtonSettings({
    this.builder,
  });

  @override
  bool operator ==(covariant EasyFormActionButtonSettings other) =>
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
