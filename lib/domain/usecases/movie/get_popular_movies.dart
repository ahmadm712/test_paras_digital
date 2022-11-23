import 'package:dartz/dartz.dart';
import 'package:paras_digital_test/common/failure.dart';
import 'package:paras_digital_test/domain/entities/movie.dart';
import 'package:paras_digital_test/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String page) {
    return repository.getPopularMovies(page);
  }
}
