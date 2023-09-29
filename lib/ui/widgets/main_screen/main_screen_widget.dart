import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/widgets/favorites/favorite_movies.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_model.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedIndex = 0;
  final movieListModel = MovieListModel();

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    movieListModel.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Column(
            children: [
              const Text('Index 0: Новости'),
              TextButton(
                onPressed: () {
                  SessionDataProvider().setSessionId(null);
                },
                child: const Text('Logout'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Get popular'),
              ),
            ],
          ),
          MovieListModelProvider(
            model: movieListModel,
            child: const MovieListWidget(),
          ),
          const Text('Index 2: Сериалы'),
          const FavoriteMovies(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.tv_off_sharp), label: 'Новости'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Фильмы'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Сериалы'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Избранные'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
