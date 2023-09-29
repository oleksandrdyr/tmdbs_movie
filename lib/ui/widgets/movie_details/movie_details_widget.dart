import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_main_screen_cast_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailWidget extends StatefulWidget {
  final int movieId;
  const MovieDetailWidget({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<MovieDetailWidget> createState() => _MovieDetailWidgetState();
}

class _MovieDetailWidgetState extends State<MovieDetailWidget> {
  final movieDetailsModel = MovieDetailsModel();
  @override
  void initState() {
    super.initState();
    movieDetailsModel.getMovieDetails(widget.movieId);
    // movieDetailsModel.getMovieVideo(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return MovieDetailsModelProvider(
      model: movieDetailsModel,
      child: const _MovieDetailWidgetBody(),
    );
  }
}

class _MovieDetailWidgetBody extends StatelessWidget {
  const _MovieDetailWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 17, 1.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    return Text(model?.movieDetails?.title ?? 'Загрузка ...');
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;

    // Пока нет movieDetails будет показываться лоадер
    if (model?.movieDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        MovieDetailsMainInfoWidget(),
        SizedBox(height: 20),
        MovieDetailsMainScreenCastWidget()
      ],
    );
  }
}
