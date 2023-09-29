import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/models/movie_credits.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/elements/radial_percent_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TopPostersWidget(),
        Padding(padding: EdgeInsets.all(20.0), child: _MovieNameWidget()),
        _ScoreWidget(),
        _SummeryWidget(),
        _OverviewWidget(),
        SizedBox(height: 30),
        _DescriptionWidget(),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: _PeopleWidget(),
        )
      ],
    );
  }
}

class _TopPostersWidget extends StatelessWidget {
  const _TopPostersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    // Чтобы не дергался контент при загрузке картинок
    return AspectRatio(
      aspectRatio: 393 / 221,
      child: Stack(
        children: [
          model?.movieDetails?.backdropPath != null
              ? Image(
                  image: NetworkImage(
                    ApiClient().imgUrl(model?.movieDetails?.backdropPath ?? ''),
                  ),
                )
              : const SizedBox.shrink(),
          Positioned(
            top: 30,
            left: 10,
            bottom: 50,
            child: model?.movieDetails?.backdropPath != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image(
                      image: NetworkImage(
                        ApiClient()
                            .imgUrl(model?.movieDetails?.posterPath ?? ''),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              icon: model?.isFavorite == true
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 40,
                    )
                  : const Icon(
                      Icons.favorite_outline,
                      color: Colors.grey,
                      size: 40,
                    ),
              onPressed: () {
                model?.toggleFavorite();
              },
            ),
          ),
          Positioned(
              child: Text(model?.successAddToFavoritesMessage ?? 'Talgat'))
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    final year =
        model?.movieDetails?.releaseDate?.year.toString() ?? 'Год не указан';
    return RichText(
      maxLines: 3,
      textAlign: TextAlign.start,
      text: TextSpan(children: [
        TextSpan(
          text: model?.movieDetails?.title ?? '',
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextSpan(
          text: ' ($year)',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ]),
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    final releaseDate = model?.movieDetails?.releaseDate;
    final productionCountries = model?.movieDetails?.productionCountries ?? [];
    final genres = model?.movieDetails?.genres ?? [];
    final runTime = model?.movieDetails?.runtime ?? 0;
    final hours = runTime / 60;
    final minutes = runTime % 60;
    final genresNames = genres.map((e) => e.name).join(', ');

    final date = releaseDate != null ? releaseDate.year.toString() : 'Нет даты';
    final countryIso = productionCountries.first.iso_3166_1;
    return Container(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
        child: Text(
          '$date ($countryIso) ${hours.toStringAsPrecision(1)}ч $minutesм $genresNames.',
          maxLines: 10,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Text(
            'Описание',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            model?.movieDetails?.overview ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            model?.movieDetails?.videos.results[0].key ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ctrl + k + 2  CloseAllBraskets
// ctrl + k + j  OpenAllBraskets

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    var crew = model?.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();

    // Если crew больше 4 то верни первые 4 иначе весь список crew
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;

// Плохо понял, сделали массив массивов из Crew чтобы потом мапаться
    var crewChunks = <List<Crew>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }

    return Column(
        children: crewChunks
            .map((chunk) => Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: _PeopleWidgetRow(crews: chunk)))
            .toList());
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<Crew> crews;
  const _PeopleWidgetRow({
    Key? key,
    required this.crews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: crews.map((crew) => _PeopleWidgetRowItem(crew: crew)).toList(),
    );
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final Crew crew;
  const _PeopleWidgetRowItem({
    Key? key,
    required this.crew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const peopleStyle = TextStyle(color: Colors.white, fontSize: 16);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(crew.name, style: peopleStyle, textAlign: TextAlign.start),
          Text(crew.job, style: peopleStyle, textAlign: TextAlign.end),
        ],
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    final videos = model?.movieDetails?.videos.results
        .where((video) => video.site == 'YouTube' && video.type == 'Trailer');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;

    final voteAverage = model?.movieDetails?.voteAverage ?? 0;

    void showTrailerWidget() {
      Navigator.of(context).pushNamed(
        MainNavigationRouteNames.movieTrailer,
        arguments: trailerKey,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: RadialPercentWidget(
                  fillColor: const Color.fromARGB(255, 24, 24, 23),
                  freeColor: const Color.fromARGB(255, 51, 57, 51),
                  lineColor: Colors.green,
                  lineWidth: 5,
                  percent: voteAverage / 10,
                  child: Text((voteAverage * 10).toStringAsFixed(0)),
                ),
              ),
              const SizedBox(width: 10),
              const Text('User Score'),
            ],
          ),
        ),
        Container(width: 1, height: 15, color: Colors.grey),
        trailerKey != null
            ? TextButton(
                onPressed: showTrailerWidget,
                child: Row(
                  children: const [
                    Icon(Icons.play_arrow),
                    Text('Play Trailer'),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
