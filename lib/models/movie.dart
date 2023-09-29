class Movie {
  String? posterPath;
  bool adult;
  String overview;
  DateTime? releaseDate;
  List<int> genreIds;
  int id;
  String originalTitle;
  String originalLanguage;
  String title;
  String? backdropPath;
  double popularity;
  int voteCount;
  bool video;
  double voteAverage;

  Movie({
    required this.posterPath,
    required this.adult,
    required this.overview,
    required this.releaseDate,
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.originalLanguage,
    required this.title,
    required this.backdropPath,
    required this.popularity,
    required this.voteCount,
    required this.video,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      posterPath: json['poster_path'] as String?,
      adult: json['adult'] as bool,
      overview: json['overview'] as String,
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date'] as String),
      genreIds:
          (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      id: json['id'] as int,
      originalTitle: json['original_title'] as String,
      originalLanguage: json['original_language'] as String,
      title: json['title'] as String,
      backdropPath: json['backdrop_path'] as String?,
      popularity: (json['popularity'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
      video: json['video'] as bool,
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}
