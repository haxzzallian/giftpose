import 'package:giftpose_app/constant/app-router.dart';
import 'package:giftpose_app/constant/locator.dart';

import 'package:giftpose_app/modules/products/view-model/products-view-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:giftpose_app/theme/app-theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ProductViewModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Giftpose',
      theme: AppTheme.lightThemeMode,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
