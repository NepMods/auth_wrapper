library auth_wrapper;

import 'package:auth_wrapper/models/AuthRoute.dart';
import 'package:flutter/material.dart';

/// A widget that checks authentication status before displaying [child].
///
/// Displays a loading indicator while [checkFunc] is running, and
/// navigates to [fallbackRoute] if not authenticated.
class AuthWrapper extends StatelessWidget {
  /// A function that returns `true` if the user is authenticated.
  final Future<bool> Function() checkFunc;

  /// Named route to navigate to when authentication fails.
  final String fallbackRoute;

  /// Widget to show when authentication succeeds.
  final Widget child;

  /// Callback to show a loading indicator (not used internally).
  final void Function() showLoading;

  /// Callback to hide a loading indicator (not used internally).
  final void Function() hideLoading;

  /// Creates an [AuthWrapper] with required authentication parameters.
  const AuthWrapper({
    required this.checkFunc,
    required this.fallbackRoute,
    required this.child,
    required this.showLoading,
    required this.hideLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkFunc(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, fallbackRoute);
          });
          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}

/// A widget that configures and wraps a [MaterialApp] with
/// public and protected routes.
///
/// Uses [AuthWrapper] internally to guard protected routes.
class UseAuth extends StatefulWidget {
  /// List of routes accessible without authentication.
  final List<AuthRoute> publicPages;
  
  /// List of routes that require authentication.
  final List<AuthRoute> protectedPages;
  
  /// Named route to use when no authentication is present (e.g., login page).
  final String noAuth;
  
  /// Function to check if the user is authenticated.
  final Future<bool> Function() checkFunc;
  
  /// Callback to show a loading indicator.
  final void Function() showLoading;
  
  /// Callback to hide a loading indicator.
  final void Function() hideLoading;
  
  /// The base [MaterialApp] configuration to extend.
  final MaterialApp app;
  
  /// Named route to navigate to when authentication succeeds.
  final String success;

  /// Creates a [UseAuth] widget to manage app routing based on auth state.
  const UseAuth({
    required this.publicPages,
    required this.protectedPages,
    required this.noAuth,
    required this.checkFunc,
    required this.showLoading,
    required this.hideLoading,
    required this.app,
    required this.success,
    super.key,
  });

  @override
  State<UseAuth> createState() => _UseAuthState();
}

class _UseAuthState extends State<UseAuth> {
  late Future<bool> loginCheckFuture;

  @override
  void initState() {
    super.initState();
    loginCheckFuture = widget.checkFunc();  
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: loginCheckFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final alreadyLoggedIn = snapshot.data ?? false;
        final routes = <String, WidgetBuilder>{};

        for (final route in widget.publicPages) {
          routes[route.path] = (context) => route.build(context);
        }

        for (final route in widget.protectedPages) {
          routes[route.path] = (context) => AuthWrapper(
                checkFunc: widget.checkFunc,
                fallbackRoute: widget.noAuth,
                child: route.build(context),
                showLoading: widget.showLoading,
                hideLoading: widget.hideLoading,
              );
        }

        return MaterialApp(
          key: widget.app.key,
          navigatorKey: widget.app.navigatorKey,
          scaffoldMessengerKey: widget.app.scaffoldMessengerKey,
          home: widget.app.home,
          routes: routes,
          initialRoute: alreadyLoggedIn ? widget.success : widget.noAuth,
          onGenerateRoute: widget.app.onGenerateRoute,
          onGenerateInitialRoutes: widget.app.onGenerateInitialRoutes,
          onUnknownRoute: widget.app.onUnknownRoute,
          onNavigationNotification: widget.app.onNavigationNotification,
          navigatorObservers: widget.app.navigatorObservers!,
          builder: widget.app.builder,
          title: widget.app.title,
          onGenerateTitle: widget.app.onGenerateTitle,
          color: widget.app.color,
          theme: widget.app.theme,
          darkTheme: widget.app.darkTheme,
          highContrastTheme: widget.app.highContrastTheme,
          highContrastDarkTheme: widget.app.highContrastDarkTheme,
          themeMode: widget.app.themeMode,
          themeAnimationDuration: widget.app.themeAnimationDuration,
          themeAnimationCurve: widget.app.themeAnimationCurve,
          locale: widget.app.locale,
          localizationsDelegates: widget.app.localizationsDelegates,
          localeListResolutionCallback: widget.app.localeListResolutionCallback,
          localeResolutionCallback: widget.app.localeResolutionCallback,
          supportedLocales: widget.app.supportedLocales,
          debugShowMaterialGrid: widget.app.debugShowMaterialGrid,
          showPerformanceOverlay: widget.app.showPerformanceOverlay,
          checkerboardRasterCacheImages: widget.app.checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: widget.app.checkerboardOffscreenLayers,
          showSemanticsDebugger: widget.app.showSemanticsDebugger,
          debugShowCheckedModeBanner: widget.app.debugShowCheckedModeBanner,
          shortcuts: widget.app.shortcuts,
          actions: widget.app.actions,
          restorationScopeId: widget.app.restorationScopeId,
          scrollBehavior: widget.app.scrollBehavior,
          useInheritedMediaQuery: widget.app.useInheritedMediaQuery,
          themeAnimationStyle: widget.app.themeAnimationStyle,
        );
      },
    );
  }
}

/// A simple 404 page displayed when a route is not found.
class NotFoundPage extends StatelessWidget {
  /// Creates a const [NotFoundPage].
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('404 - Page Not Found')),
    );
  }
}
