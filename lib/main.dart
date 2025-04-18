import 'package:flutter/material.dart';
import 'package:tree_app/config/routes/routes_path.dart';
import 'package:tree_app/namoo_app.dart';

import 'config/routes/router.dart';
import 'core/cache/shared_pref.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService().init();
  bool isStart = SharedPrefService().getBool('isStart') ?? false;
  String initialRoute = isStart ? RoutePath.home : RoutePath.getStarted;
  runApp(NamooApp(appRouter: AppRouter() , initialRoute:initialRoute,),);}

