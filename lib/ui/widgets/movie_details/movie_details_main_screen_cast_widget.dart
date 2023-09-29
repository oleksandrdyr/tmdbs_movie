import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/models/movie_credits.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'В главных ролях',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 300,
            child: Scrollbar(
              child: _ActorList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextButton(
              child: const Text('Ful Cast & Crew'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ActorList extends StatelessWidget {
  const _ActorList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    var cast = model?.movieDetails?.credits.cast;
    if (cast == null || cast.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      itemCount: 20,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        var actor = cast[index];

        return _ActorListItemWidget(actor: actor);
      },
    );
  }
}

class _ActorListItemWidget extends StatelessWidget {
  const _ActorListItemWidget({
    Key? key,
    required this.actor,
  }) : super(key: key);

  final Cast actor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black.withOpacity(0.2)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              actor.profilePath != null
                  ? Image(
                      image: NetworkImage(
                      ApiClient().imgUrl(actor.profilePath ?? ''),
                    ))
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actor.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      actor.character,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
