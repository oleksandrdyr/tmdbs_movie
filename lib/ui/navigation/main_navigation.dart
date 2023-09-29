import 'package:flutter/cupertino.dart';
import 'package:themoviedb/ui/widgets/movie_trailer/movie_trailer_widget.dart';

import '../widgets/auth/auth_model.dart';
import '../widgets/auth/auth_widget.dart';
import '../widgets/main_screen/main_screen_widget.dart';
import '../widgets/movie_details/movie_details_widget.dart';

class MainNavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = '/';
  static const movieDetails = '/movie_details';
  static const movieTrailer = '/movie_details/trailer';
}

class MainNavigation {
  // Если авторизован то на главную иначе на страницу авторизации
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRouteNames.mainScreen
      : MainNavigationRouteNames.auth;

  final routes = <String, Widget Function(BuildContext context)>{
    MainNavigationRouteNames.auth: (context) => AuthModelProvider(
          model: AuthModel(),
          child: const AuthWidget(),
        ),
    MainNavigationRouteNames.mainScreen: (context) => const MainScreenWidget(),
    MainNavigationRouteNames.movieDetails: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is int) {
        return MovieDetailWidget(movieId: arguments);
      }
      return const MovieDetailWidget(movieId: 0);
    },
    MainNavigationRouteNames.movieTrailer: (context) {
      final youtubeKey = ModalRoute.of(context)?.settings.arguments;
      if (youtubeKey is String) {
        return MovieTrailerWidget(youtubeKey: youtubeKey);
      }
      return const MovieTrailerWidget(youtubeKey: '');
    }
  };
}
