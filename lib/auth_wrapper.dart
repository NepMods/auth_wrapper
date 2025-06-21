library auth_wrapper;

import 'package:auth_wrapper/models/AuthRoute.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  final Future<bool> Function() checkFunc;
  final String fallbackRoute;
  final Widget child;
  final void Function() showLoading;
  final void Function() hideLoading;

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

class UseAuth extends StatefulWidget {
  final List<AuthRoute> publicPages;
  final List<AuthRoute> protectedPages;
  final String noAuth;
  final Future<bool> Function() checkFunc;
  final void Function() showLoading;
  final void Function() hideLoading;
  final MaterialApp app;
  final String success;

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

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('404 - Page Not Found')),
    );
  }
}
