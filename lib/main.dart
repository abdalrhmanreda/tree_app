import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tree_app/config/routes/routes_path.dart';
import 'package:tree_app/namoo_app.dart';

import 'config/routes/router.dart';
import 'core/cache/shared_pref.dart';
import 'core/observer/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService().init();
  Bloc.observer = MyBlocObserver();

  bool isStart = SharedPrefService().getBool('isStart') ?? false;
  String initialRoute = isStart ? RoutePath.home : RoutePath.getStarted;
  runApp(NamooApp(appRouter: AppRouter(), initialRoute: initialRoute));
}
