

import 'package:flutter/material.dart';

class SelectorListener<T> extends StatefulWidget {
  final T Function(BuildContext context) selector;
  final void Function(BuildContext context, T value) listener;
  final Widget child;

  const SelectorListener({super.key,
    required this.selector,
    required this.listener,
    required this.child,
  });

  @override
  State<SelectorListener<T>> createState() => _SelectorListenerState<T>();
}

class _SelectorListenerState<T> extends State<SelectorListener<T>> {
  T? _previous;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selector(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_previous != selected) {
        widget.listener(context, selected);
        _previous = selected;
      }
    });

    return widget.child;
  }
}