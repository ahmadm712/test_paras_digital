import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paras_digital_test/domain/entities/movie.dart';
import 'package:paras_digital_test/domain/usecases/movie/get_watchlist_movies.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  GetWatchlistMovies getWatchlistMovies;
  WatchlistMovieBloc(this.getWatchlistMovies) : super(WatchlistMovieEmpty()) {
    on<FetchWatchListMovie>((event, emit) async {
      emit(WatchlistMovieLoading());

      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (data) => emit(
          WatchlistMovieHasData(data),
        ),
      );
    });
  }
}
