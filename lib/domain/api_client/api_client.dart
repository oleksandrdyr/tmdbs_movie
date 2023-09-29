import 'dart:core';

import 'package:dio/dio.dart';
import 'package:themoviedb/models/movie.dart';
import 'package:themoviedb/models/movie_details.dart';
import 'package:themoviedb/models/popular_movie_response.dart';

class ApiClient {
  static const _host = 'https://api.themoviedb.org/3';
  static const _apiKey = '45d71cc1fac6b4ade96f86ce70d3748c';

  /* 
            ЛОГИКА АВТОРИЗАЦИИ
  1) Получить токен - get запрос
  2) С полученным токеном подтвердить пользователя - post запрос
  3) Передав валидный токен получить доступ к сессии - post запрос
   */

// Функция хелпер для авторизации со всеми этапами внутри, поэтому сами функции сделал _приватными
  Future<String> auth(
      {required String userName, required String password}) async {
    try {
      // Получаем токен
      final token = await _makeToken();
      // Подтверждаем Юзера передав (имя, пароль, токен)
      final validToken = await _validateUser(
        userName: userName,
        password: password,
        requestToken: token,
      );
      // Подучаем доступ к сессии передав подтвержденный токен
      final sessionId = await _makeSession(requestToken: validToken);
      // Закончили авторизацию получив sessionId
      return sessionId;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _makeToken() async {
    try {
      final response =
          await Dio().get('$_host/authentication/token/new?api_key=$_apiKey');
      final Map<String, dynamic> json = response.data;
      // Из обьекта получаем только token
      final token = json['request_token'] as String;
      return token;
    } on DioError catch (dioError) {
      final is401 = dioError.response?.statusCode == 401;
      final is404 = dioError.response?.statusCode == 404;
      if (is401 || is404) {
        final dioResponse = dioError.response;
        final data = dioResponse?.data as Map<String, dynamic>?;
        if (data != null) {
          final errorMessage = data['status_message'] as String?;
          throw Exception(errorMessage);
        }
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _validateUser({
    required String userName,
    required String password,
    required String requestToken,
  }) async {
    try {
      final response = await Dio().post(
          '$_host/authentication/token/validate_with_login?api_key=$_apiKey',
          data: {
            'username': userName,
            'password': password,
            'request_token': requestToken,
          });
      final Map<String, dynamic> json = response.data;
      // Из обьекта получаем только валидный токен
      final token = json['request_token'] as String;
      return token;
    } on DioError catch (dioError) {
      final is401 = dioError.response?.statusCode == 401;
      final is404 = dioError.response?.statusCode == 404;
      if (is401 || is404) {
        final dioResponse = dioError.response;
        final data = dioResponse?.data as Map<String, dynamic>?;
        if (data != null) {
          final errorMessage = data['status_message'] as String?;
          throw Exception(errorMessage);
        }
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    try {
      final response = await Dio().post(
        '$_host/authentication/session/new?api_key=$_apiKey',
        // Передаем подтвержденный токен полученный в параметрах
        data: {'request_token': requestToken},
      );
      final Map<String, dynamic> json = response.data;
      final sessionId = json['session_id'] as String;
      // Из обьекта получаем только нужный нам sessionId
      return sessionId;
    } on DioError catch (dioError) {
      final is401 = dioError.response?.statusCode == 401;
      final is404 = dioError.response?.statusCode == 404;
      if (is401 || is404) {
        final dioResponse = dioError.response;
        final data = dioResponse?.data as Map<String, dynamic>?;
        if (data != null) {
          final errorMessage = data['status_message'] as String?;
          throw Exception(errorMessage);
        }
      }
      rethrow;
    }
  }

  Future<PopularMovieResponse> getPopularMovies(int page) async {
    try {
      final response =
          await Dio().get('$_host/movie/popular?api_key=$_apiKey&page=$page');
      final Map<String, dynamic> json = response.data;

      return PopularMovieResponse.fromJson(json);
    } on DioError catch (_) {
      rethrow;
    }
  }

  Future<PopularMovieResponse> searchMovie(String query, int page) async {
    final response = await Dio()
        .get('$_host/search/movie?api_key=$_apiKey&query=$query&page=$page');
    final Map<String, dynamic> json = response.data;
    return PopularMovieResponse.fromJson(json);
  }

  Future<MovieDetails> getMovieDetails(int id) async {
    try {
      final response = await Dio().get(
          '$_host/movie/$id?api_key=$_apiKey&language=ru-Ru&append_to_response=credits,videos');
      final Map<String, dynamic> json = response.data;

      return MovieDetails.fromJson(json);
    } on DioError catch (_) {
      rethrow;
    }
  }

  Future<bool> isFavorit(int movieId, String sessionId) async {
    final response = await Dio().get(
        '$_host/movie/$movieId/account_states?api_key=$_apiKey&session_id=$sessionId');
    final Map<String, dynamic> json = response.data;
    final result = json['favorite'] as bool;
    return result;
  }

  Future<int> getAccountId(String sessionId) async {
    // Пытаемся получить accountId
    final response = await Dio()
        .get('$_host/account?api_key=$_apiKey&session_id=$sessionId');
    final Map<String, dynamic> json = response.data;
    final accountId = json['id'] as int;
    return accountId;
  }

  Future<String> markAsFavorite({
    required int accountId,
    required String sessionId,
    required String mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    final apiKeyAndSessionId = 'api_key=$_apiKey&session_id=$sessionId';
    final results = await Dio()
        .post('$_host/account/$accountId/favorite?$apiKeyAndSessionId', data: {
      "media_type": mediaType,
      "media_id": mediaId,
      "favorite": isFavorite,
    });
    final Map<String, dynamic> mapResults = results.data;
    final String successMessage = mapResults['status_message'] as String;
    return successMessage;
  }

  Future<List<Movie>> getFavoriteMovies(
      {required String sessionId, required int accountId}) async {
    final apiKeyAndSessionId = 'api_key=$_apiKey&session_id=$sessionId';
    // Пытаемся получаем favorites
    final response = await Dio()
        .get('$_host/account/$accountId/favorite/movies?$apiKeyAndSessionId');
    final Map<String, dynamic> json = response.data;
    final listMovies = json['results'] as List;
    final favoriteMovies = listMovies
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
    return favoriteMovies;
  }

  String imgUrl(String url) => 'https://image.tmdb.org/t/p/original/$url';
}
