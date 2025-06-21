library auth_wrapper;

import 'package:flutter/material.dart';

class AuthRoute {
  final String path;
  final Widget Function(BuildContext context, Object? arguments)? builder;
  final Widget? widget;
  AuthRoute.builder(this.path, this.builder)
      : widget = null;
  AuthRoute.static(this.path, this.widget)
      : builder = null;

  Widget build(BuildContext context) {
    if (builder != null) {
      final args = ModalRoute.of(context)!.settings.arguments;
      return builder!(context, args);
    } else if (widget != null) {
      return widget!;
    } else {
      return const SizedBox.shrink();
    }
  }
}
