import 'package:easy_form_kit/src/easy_form_field_error.dart';
import 'package:flutter/foundation.dart';

/// Sets default builders for [EasyFormFieldError].
@immutable
class EasyFormFieldErrorSettings with Diagnosticable {
  /// Widget builder for error display.
  final EasyFormFieldErrorBuilder? builder;

  /// Creates default settings for [EasyFormFieldError].
  EasyFormFieldErrorSettings({
    this.builder,
  });

  @override
  bool operator ==(covariant EasyFormFieldErrorSettings other) =>
      (builder == other.builder);

  @override
  int get hashCode => builder.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<EasyFormFieldErrorBuilder?>.has('builder', builder));
  }
}
