import 'package:dartz/dartz.dart';
import 'package:paras_digital_test/common/failure.dart';
import 'package:paras_digital_test/domain/entities/movie_detail.dart';
import 'package:paras_digital_test/domain/repositories/movie_repository.dart';

class RemoveWatchlist {
  final MovieRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
