import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paras_digital_test/domain/entities/movie_detail.dart';
import 'package:paras_digital_test/domain/usecases/movie/get_movie_detail.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  MovieDetailBloc({
    required this.getMovieDetail,
  }) : super(
          MovieDetailEmpty(),
        ) {
    on<FetchMovieDetail>(
      (event, emit) async {
        emit(
          MovieDetailLoading(),
        );

        final result = await getMovieDetail.execute(event.id);

        result.fold(
          (failure) => emit(
            MovieDetailError(failure.message),
          ),
          (data) => emit(
            MovieDetailHasData(data),
          ),
        );
      },
    );
  }
}
