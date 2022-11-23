import 'package:dartz/dartz.dart';
import 'package:paras_digital_test/common/failure.dart';
import 'package:paras_digital_test/domain/entities/movie.dart';
import 'package:paras_digital_test/domain/entities/movie_detail.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies(String page);

  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);

  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie);
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Movie>>> getWatchlistMovies();
}
