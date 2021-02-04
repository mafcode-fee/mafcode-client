import 'package:flutter/material.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/screens/login/login_screen.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

class MafcodeApp extends StatefulWidget {
  @override
  _MafcodeAppState createState() => _MafcodeAppState();
}

class _MafcodeAppState extends State<MafcodeApp> {
  final _autoRouter = AutoRouterConfig();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MafCode - مفقود',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            centerTitle: true,
          )),
      navigatorKey: NavigationService.navigationKey,
      onGenerateRoute: _autoRouter.onGenerateRoute,
    );
  }
}
