import 'package:easy_form_kit/src/indicators/save_indicator.dart';
import 'package:flutter/foundation.dart';

/// Sets default builders for [EasyFormSaveIndicator].
@immutable
class EasyFormSaveIndicatorSettings with Diagnosticable {
  /// The builder of the indicator on top of a child, displayed
  /// during the save process.
  final EasyFormSaveIndicatorBuilder? builder;

  /// Indicator layout builder
  final EasyFormSaveIndicatorLayoutBuilder? layoutBuilder;

  /// Creates default settings for [EasyFormSaveIndicator].
  EasyFormSaveIndicatorSettings({
    this.builder,
    this.layoutBuilder,
  });

  @override
  bool operator ==(covariant EasyFormSaveIndicatorSettings other) =>
      (builder == other.builder) && (layoutBuilder == other.layoutBuilder);

  @override
  int get hashCode => Object.hash(builder, layoutBuilder);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<EasyFormSaveIndicatorBuilder?>.has(
        'builder', builder));
    properties.add(ObjectFlagProperty<EasyFormSaveIndicatorLayoutBuilder?>.has(
        'layoutBuilder', layoutBuilder));
  }
}
