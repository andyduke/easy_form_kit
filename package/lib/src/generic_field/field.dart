import 'package:flutter/widgets.dart';

import 'controller.dart';

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
