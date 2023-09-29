import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_model.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieListModelProvider.watch(context)?.model;

    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(top: 60),
          itemCount: model?.movies.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, index) {
            // Вызываем функцию каждый раз при показе карточки
            model?.showMovieAtIndex(index);
            final movie = model?.movies[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Image(
                          image: NetworkImage(
                            'https://image.tmdb.org/t/p/original/${movie?.posterPath}',
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${movie?.title}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${movie?.releaseDate?.day}/${movie?.releaseDate?.month}/${movie?.releaseDate?.year} г.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.grey)),
                              Text(
                                '${movie?.overview}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5)
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () => {
                        model?.onMovieTap(context, index),
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: model?.searchMovie,
            decoration: InputDecoration(
              labelText: 'Search ...',
              filled: true,
              fillColor: Colors.white.withAlpha(230),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
