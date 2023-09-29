import 'package:themoviedb/models/movie.dart';

class PopularMovieResponse {
  final int page;
  final List<Movie> results;
  final int totalResults;
  final int totalPages;

  PopularMovieResponse({
    required this.page,
    required this.results,
    required this.totalResults,
    required this.totalPages,
  });

  factory PopularMovieResponse.fromJson(Map<String, dynamic> json) {
    return PopularMovieResponse(
      page: json['page'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: json['total_results'] as int,
      totalPages: json['total_pages'] as int,
    );
  }
}
