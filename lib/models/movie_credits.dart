class MovieCredits {
  final List<Cast> cast;
  final List<Crew> crew;

  MovieCredits({
    required this.cast,
    required this.crew,
  });

  factory MovieCredits.fromJson(Map<String, dynamic> json) {
    return MovieCredits(
      cast: (json['cast'] as List<dynamic>)
          .map((e) => Cast.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => Crew.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Cast {
  final bool adult;
  final int? gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final num popularity;
  final String? profilePath;
  final int castId;
  final String character;
  final String creditId;
  final int order;

  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      adult: json['adult'] as bool,
      gender: json['gender'] as int?,
      id: json['id'] as int,
      knownForDepartment: json['known_for_department'] as String,
      name: json['name'] as String,
      originalName: json['original_name'] as String,
      popularity: json['popularity'] as num,
      profilePath: json['profile_path'] as String?,
      castId: json['cast_id'] as int,
      character: json['character'] as String,
      creditId: json['credit_id'] as String,
      order: json['order'] as int,
    );
  }
}

class Crew {
  final bool adult;
  final int? gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final num popularity;
  final String? profilePath;
  final String creditId;
  final String department;
  final String job;

  Crew({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.creditId,
    required this.department,
    required this.job,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      adult: json['adult'] as bool,
      gender: json['gender'] as int?,
      id: json['id'] as int,
      knownForDepartment: json['known_for_department'] as String,
      name: json['name'] as String,
      originalName: json['original_name'] as String,
      popularity: json['popularity'] as num,
      profilePath: json['profile_path'] as String?,
      creditId: json['credit_id'] as String,
      department: json['department'] as String,
      job: json['job'] as String,
    );
  }
}
