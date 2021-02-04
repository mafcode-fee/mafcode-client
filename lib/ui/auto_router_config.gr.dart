// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'screens/login/login_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/matches/matches_screen.dart';
import 'screens/report/report_screen.dart';

class Routes {
  static const String loginScreen = '/';
  static const String mainScreen = '/main-screen';
  static const String reportScreen = '/report-screen';
  static const String matchesScreen = '/matches-screen';
  static const all = <String>{
    loginScreen,
    mainScreen,
    reportScreen,
    matchesScreen,
  };
}

class AutoRouterConfig extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.loginScreen, page: LoginScreen),
    RouteDef(Routes.mainScreen, page: MainScreen),
    RouteDef(Routes.reportScreen, page: ReportScreen),
    RouteDef(Routes.matchesScreen, page: MatchesScreen),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    LoginScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LoginScreen(),
        settings: data,
      );
    },
    MainScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MainScreen(),
        settings: data,
      );
    },
    ReportScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ReportScreen(),
        settings: data,
      );
    },
    MatchesScreen: (data) {
      final args = data.getArgs<MatchesScreenArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => MatchesScreen(
          key: args.key,
          file: args.file,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// MatchesScreen arguments holder class
class MatchesScreenArguments {
  final Key key;
  final File file;
  MatchesScreenArguments({this.key, @required this.file});
}
