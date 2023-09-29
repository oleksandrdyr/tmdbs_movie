import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/models/movie.dart';
import 'package:themoviedb/models/popular_movie_response.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final _movies = <Movie>[];
  late int _currentPage = 0;
  late int _totalPages = 1;
  var _isLoadingInProgres = false;
  String? _searchQuery;
  Timer? searchDebounce;

  List<Movie> get movies => _movies;

  Future<PopularMovieResponse> loadMovies(int nextPage) async {
    final query = _searchQuery;
    if (query == null) {
      return await _apiClient.getPopularMovies(nextPage);
    } else {
      return await _apiClient.searchMovie(query, nextPage);
    }
  }

  Future<void> getMovies() async {
    // Вот это понял плохо
    if (_isLoadingInProgres || _currentPage >= _totalPages) return;
    _isLoadingInProgres = true;
    final nextPage = _currentPage + 1;
    try {
      final response = await loadMovies(nextPage);
      _movies.addAll(response.results);
      _currentPage = response.page;
      _totalPages = response.totalPages;
      _isLoadingInProgres = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgres = false;
    }
  }

  /*
   Когда человек вводит текст в поисковике:
  1) Если текс есть он присваивается searchQuery
  2) Обнуляем номера страниц
  3) Очищается весь старый список фильмов
  4) Вызывается каждый раз функция getMovies()
*/

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(seconds: 1), () async {
      _searchQuery = text.isNotEmpty ? text : null;
      _currentPage = 0;
      _totalPages = 1;
      _movies.clear();
      await getMovies();
    });
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  void showMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    getMovies();
  }
}

class MovieListModelProvider extends InheritedNotifier {
  final MovieListModel model;
  const MovieListModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(
          key: key,
          child: child,
          notifier: model,
        );

  static MovieListModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MovieListModelProvider>();
  }

  static MovieListModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MovieListModelProvider>()
        ?.widget;
    return widget is MovieListModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
