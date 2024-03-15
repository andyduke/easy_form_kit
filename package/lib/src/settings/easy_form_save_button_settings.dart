import 'package:easy_form_kit/src/buttons/action_button.dart';
import 'package:easy_form_kit/src/buttons/save_button.dart';
import 'package:flutter/foundation.dart';

/// Sets default builders for [EasyFormSaveButton].
@immutable
class EasyFormSaveButtonSettings with Diagnosticable {
  /// The default button builder.
  final EasyFormActionButtonBuilder? builder;

  /// Button content layout builder.
  final EasyFormSaveButtonLayoutBuilder? layoutBuilder;

  /// The builder of the indicator inside the button displayed
  /// during the save process.
  final EasyFormSaveButtonIndicatorBuilder? indicatorBuilder;

  /// Creates default settings for [EasyFormSaveButton].
  EasyFormSaveButtonSettings({
    this.builder,
    this.layoutBuilder,
    this.indicatorBuilder,
  });

  @override
  bool operator ==(covariant EasyFormSaveButtonSettings other) =>
      (builder == other.builder) &&
      (layoutBuilder == other.layoutBuilder) &&
      (indicatorBuilder == other.indicatorBuilder);

  @override
  int get hashCode => Object.hash(builder, layoutBuilder, indicatorBuilder);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<EasyFormActionButtonBuilder?>.has(
        'builder', builder));
    properties.add(ObjectFlagProperty<EasyFormSaveButtonLayoutBuilder?>.has(
        'layoutBuilder', layoutBuilder));
    properties.add(ObjectFlagProperty<EasyFormSaveButtonIndicatorBuilder?>.has(
        'indicatorBuilder', indicatorBuilder));
  }
}
