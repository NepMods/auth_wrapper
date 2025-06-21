library auth_wrapper.models;

import 'package:flutter/material.dart';

/// Represents a route in the authentication system.
///
/// Provides two constructors:
/// - [AuthRoute.builder]: for dynamic routes with arguments.
/// - [AuthRoute.static]: for static routes without arguments.
class AuthRoute {
  /// The route name/path used for navigation.
  final String path;

  /// Optional builder function that receives [BuildContext] and route arguments.
  ///
  /// When non-null, used to construct the widget dynamically.
  final Widget Function(BuildContext context, Object? arguments)? builder;

  /// Optional static widget to display for this route.
  ///
  /// When non-null and [builder] is null, used directly as the route's page.
  final Widget? widget;

  /// Creates an [AuthRoute] with a dynamic [builder].
  ///
  /// Use this when the route needs to read arguments from navigation settings.
  AuthRoute.builder(this.path, this.builder)
      : widget = null;

  /// Creates an [AuthRoute] with a static [widget].
  ///
  /// Use this for routes that don't require arguments.
  AuthRoute.static(this.path, this.widget)
      : builder = null;

  /// Builds the widget for this route.
  ///
  /// If [builder] is provided, retrieves arguments via
  /// `ModalRoute.of(context)?.settings.arguments` and invokes the builder.
  /// Otherwise, returns the static [widget], or an empty box if neither is set.
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
