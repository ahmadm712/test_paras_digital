import 'dart:convert';

import 'package:paras_digital_test/common/exception.dart';
import 'package:paras_digital_test/data/models/movie_detail_model.dart';
import 'package:paras_digital_test/data/models/movie_model.dart';
import 'package:paras_digital_test/data/models/movie_response.dart';
import 'package:http/http.dart' as http;

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies(String page);
  Future<MovieDetailResponse> getMovieDetail(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response =
        await client.get(Uri.parse('$BASE_URL/movie/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies(String page) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/movie/popular?$API_KEY&page=$page'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }
}
