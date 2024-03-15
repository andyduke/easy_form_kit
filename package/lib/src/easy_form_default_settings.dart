import 'package:easy_form_kit/src/settings/easy_form_action_button_settings.dart';
import 'package:easy_form_kit/src/settings/easy_form_field_error_settings.dart';
import 'package:easy_form_kit/src/settings/easy_form_reset_button_settings.dart';
import 'package:easy_form_kit/src/settings/easy_form_save_button_settings.dart';
import 'package:easy_form_kit/src/settings/easy_form_save_indicator_settings.dart';
import 'package:flutter/widgets.dart';

/// Sets global default values for the parameters of an [EasyForm] and its widgets.
///
/// This widget can be placed in [MaterialApp.builder] to have access to the application
/// theme and globally set the appearance of buttons, indicators, etc. for the [EasyForm].
class EasyFormDefaultSettings extends InheritedWidget {
  /// Default parameters for the [EasyFormSaveIndicator].
  final EasyFormSaveIndicatorSettings? saveIndicator;

  /// Default parameters for the [EasyFormActionButton].
  final EasyFormActionButtonSettings? actionButton;

  /// Default parameters for the [EasyFormResetButton].
  final EasyFormResetButtonSettings? resetButton;

  /// Default parameters for the [EasyFormSaveButton].
  final EasyFormSaveButtonSettings? saveButton;

  /// Default parameters for the [EasyFormFieldError].
  final EasyFormFieldErrorSettings? error;

  /// Creates a default [EasyForm] settings widget.
  EasyFormDefaultSettings({
    super.key,
    required super.child,
    this.saveIndicator,
    this.actionButton,
    this.resetButton,
    this.saveButton,
    this.error,
  });

  @override
  bool updateShouldNotify(covariant EasyFormDefaultSettings oldWidget) =>
      (saveIndicator != oldWidget.saveIndicator) ||
      (actionButton != oldWidget.actionButton) ||
      (resetButton != oldWidget.resetButton) ||
      (saveButton != oldWidget.saveButton) ||
      (error != oldWidget.error);

  /// Returns the closest [EasyFormDefaultSettings] which encloses the given context.
  ///
  /// Returns null if there is no EasyFormDefaultSettings associated with the given context.
  ///
  /// Calling this method will create a dependency on the closest [EasyFormDefaultSettings] in the context,
  /// if there is one.
  static EasyFormDefaultSettings? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<EasyFormDefaultSettings>();
  }

  /// Returns the closest [EasyFormDefaultSettings] which encloses the given context.
  ///
  /// If no ancestor is found, this method will assert in debug mode, and throw an exception in release mode.
  ///
  /// Calling this method will create a dependency on the closest [EasyFormDefaultSettings] in the context,
  /// if there is one.
  static EasyFormDefaultSettings of(BuildContext context) {
    final EasyFormDefaultSettings? result = maybeOf(context);
    assert(result != null, 'No EasyFormDefaultSettings found in context');
    return result!;
  }
}
