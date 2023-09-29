import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/app/my_app_model.dart';

import '../../navigation/main_navigation.dart';
import '../../theme/app_colors.dart';

class MyApp extends StatelessWidget {
  final MyAppModel model;
  static final mainNavigation = MainNavigation();
  const MyApp({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      color: Colors.red,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.mainDarkBlue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
        primarySwatch: Colors.blue,
      ),
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute(model.isAuth),
    );
  }
}
