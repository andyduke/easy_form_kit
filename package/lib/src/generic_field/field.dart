import 'package:flutter/widgets.dart';
import 'controller.dart';

/// Base class for creating a form field.
///
/// It can be used as a basis for creating a custom field for a form,
/// where controller support and processing of value changes
/// are already implemented.
///
/// The value property allows you to read the value of the associated
/// controller and change it; when the value changes, the field widget
/// will also be rebuilt.
///
/// The descendant at least needs to implement a constructor
/// and the `build` method.
///
/// An example of implementing a custom form field for choosing a color,
/// together with the [EasyFormFieldController] constructor:
/// ```dart
/// class ColorController extends EasyFormFieldController<Color> {
///   ColorController(Color value) : super(value);
/// }
///
/// class ColorField extends EasyFormGenericField<Color> {
///   ColorField({
///     Key key,
///     @required ColorController controller,
///     ValueChanged<Color> onChange,
///   }) : super(
///           key: key,
///           controller: controller,
///           onChange: onChange,
///         );
///
///   void _change() {
///     value = _getRandomColor();
///   }
///
///   Color _getRandomColor() {
///     return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Align(
///       alignment: Alignment.centerLeft,
///       child: GestureDetector(
///         onTap: _change,
///         child: Container(
///           width: 50,
///           height: 50,
///           decoration: BoxDecoration(
///             color: value,
///             border: Border.all(
///               color: Color(0xFF000000),
///               width: 2,
///             ),
///             shape: BoxShape.circle,
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
abstract class EasyFormGenericField<T> extends StatefulWidget {
  final EasyFormFieldController<T> controller;
  final ValueChanged<T> onChange;

  const EasyFormGenericField({
    Key key,
    @required this.controller,
    this.onChange,
  })  : assert(controller != null),
        super(key: key);

  Widget build(BuildContext context);

  T get value => controller.value;

  set value(T newValue) {
    controller.value = newValue;
    onChange?.call(controller.value);
  }

  @override
  _EasyFormGenericFieldState<T> createState() => _EasyFormGenericFieldState<T>();
}

class _EasyFormGenericFieldState<T> extends State<EasyFormGenericField<T>> {
  @override
  void initState() {
    widget.controller.addListener(_update);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EasyFormGenericField<T> oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_update);
      widget.controller.addListener(_update);
    }

    super.didUpdateWidget(oldWidget);
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}
