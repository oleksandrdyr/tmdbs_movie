import 'package:themoviedb/models/movie_credits.dart';
import 'package:themoviedb/models/movie_details_videos.dart';

class MovieDetails {
  final bool adult;
  final String? backdropPath;
  final Map<String, dynamic>? belongsToCollection;
  final int budget;
  final List<Genres> genres;
  final String? homePage;
  final int id;
  final String? imdbId;
  final String originalLanguage;
  final String originalTitle;
  final String? overview;
  final double popularity;
  final String? posterPath;
  final List<ProductionCompanies> productionCompanies;
  final List<ProductionCountries> productionCountries;
  final DateTime? releaseDate;
  final int revenue;
  final int? runtime;
  final List<SpokenLanguages> spokenLanguages;
  final String status;
  final String? tagLine;
  final String title;
  final bool video;
  final num voteAverage;
  final int voteCount;
  final MovieCredits credits;
  final MovieDetailsVideos videos;

  MovieDetails({
    required this.adult,
    required this.backdropPath,
    required this.belongsToCollection,
    required this.budget,
    required this.genres,
    required this.homePage,
    required this.id,
    required this.imdbId,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    required this.tagLine,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.credits,
    required this.videos,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      adult: json['adult'] as bool,
      backdropPath: json['backdrop_path'] as String,
      belongsToCollection:
          json['belongs_to_collection'] as Map<String, dynamic>?,
      budget: json['budget'] as int,
      genres: (json['genres'] as List<dynamic>)
          .map((e) => Genres.fromJson(e))
          .toList(),
      homePage: json['homepage'] as String?,
      id: json['id'] as int,
      imdbId: json['imdb_id'] as String?,
      originalLanguage: json['original_language'] as String,
      originalTitle: json['original_title'] as String,
      overview: json['overview'] as String?,
      popularity: json['popularity'] as double,
      posterPath: json['poster_path'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>)
          .map((e) => ProductionCompanies.fromJson(e))
          .toList(),
      productionCountries: (json['production_countries'] as List<dynamic>)
          .map((e) => ProductionCountries.fromJson(e))
          .toList(),
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date'] as String),
      revenue: json['revenue'] as int,
      runtime: json['runtime'] as int?,
      spokenLanguages: (json['spoken_languages'] as List<dynamic>)
          .map((e) => SpokenLanguages.fromJson(e))
          .toList(),
      status: json['status'] as String,
      tagLine: json['tagline'] as String?,
      title: json['title'] as String,
      video: json['video'] as bool,
      voteAverage: json['vote_average'] as num,
      voteCount: json['vote_count'] as int,
      credits: MovieCredits.fromJson(
        json['credits'] as Map<String, dynamic>,
      ),
      videos: MovieDetailsVideos.fromJson(
        json['videos'] as Map<String, dynamic>,
      ),
    );
  }
}

class Genres {
  final int id;
  final String name;

  Genres({
    required this.id,
    required this.name,
  });

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ProductionCompanies {
  final String name;
  final int id;
  final String? logoPath;
  final String originCountry;

  ProductionCompanies({
    required this.name,
    required this.id,
    required this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompanies.fromJson(Map<String, dynamic> json) {
    return ProductionCompanies(
      name: json['name'] as String,
      id: json['id'] as int,
      logoPath: json['logo_path'] as String?,
      originCountry: json['origin_country'] as String,
    );
  }
}

class ProductionCountries {
  final String iso_3166_1;
  final String name;

  ProductionCountries({
    required this.iso_3166_1,
    required this.name,
  });

  factory ProductionCountries.fromJson(Map<String, dynamic> json) {
    return ProductionCountries(
      iso_3166_1: json['iso_3166_1'] as String,
      name: json['name'] as String,
    );
  }
}

class SpokenLanguages {
  final String iso_639_1;
  final String name;

  SpokenLanguages({
    required this.iso_639_1,
    required this.name,
  });

  factory SpokenLanguages.fromJson(Map<String, dynamic> json) {
    return SpokenLanguages(
      iso_639_1: json['iso_639_1'] as String,
      name: json['name'] as String,
    );
  }
}
