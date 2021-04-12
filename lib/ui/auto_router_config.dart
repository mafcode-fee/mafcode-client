import 'package:auto_route/auto_route_annotations.dart';
import 'package:mafcode/ui/screens/login/login_screen.dart';
import 'package:mafcode/ui/screens/registration/registration_screen.dart';
import 'package:mafcode/ui/screens/main/main_screen.dart';
import 'package:mafcode/ui/screens/matches/matches_screen.dart';
import 'package:mafcode/ui/screens/report/report_screen.dart';

@MaterialAutoRouter(routes: [
  AutoRoute(page: RegistrationScreen),
  AutoRoute(page: LoginScreen, initial: true),
  AutoRoute(page: MainScreen),
  AutoRoute(page: ReportScreen),
  AutoRoute(page: MatchesScreen)
])
class $AutoRouterConfig {}
