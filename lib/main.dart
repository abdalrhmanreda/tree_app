import 'package:flutter/material.dart';
import 'package:tree_app/namoo_app.dart';

import 'config/routes/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(NamooApp(appRouter: AppRouter()));}

