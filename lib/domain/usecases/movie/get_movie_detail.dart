import 'package:dartz/dartz.dart';
import 'package:paras_digital_test/common/failure.dart';
import 'package:paras_digital_test/domain/entities/movie_detail.dart';
import 'package:paras_digital_test/domain/repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
