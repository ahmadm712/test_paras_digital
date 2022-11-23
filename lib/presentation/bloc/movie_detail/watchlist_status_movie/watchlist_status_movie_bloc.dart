import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paras_digital_test/domain/entities/movie_detail.dart';
import 'package:paras_digital_test/domain/usecases/movie/get_watchlist_status.dart';
import 'package:paras_digital_test/domain/usecases/movie/remove_watchlist.dart';
import 'package:paras_digital_test/domain/usecases/movie/save_watchlist.dart';

part 'watchlist_status_movie_event.dart';
part 'watchlist_status_movie_state.dart';

class WatchlistStatusMovieBloc
    extends Bloc<WatchlistStatusMovieEvent, WatchlistStatusMovieState> {
  static const successMessageAddWatchlist = 'Added to Watchlist';
  static const successMessageRemoveWatchlist = 'Removed from Watchlist';

  final GetWatchListStatus getWatchlistStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  WatchlistStatusMovieBloc(
      {required this.getWatchlistStatus,
      required this.saveWatchlist,
      required this.removeWatchlist})
      : super(
          const WatchlistStatusMovieState(false, ''),
        ) {
    on<AddWatchlistMovie>(
      (event, emit) async {
        final result = await saveWatchlist.execute(event.movieDetail);
        String message = '';

        result.fold(
          (failure) => message = failure.message,
          (succes) => message = successMessageAddWatchlist,
        );

        final status = await getWatchlistStatus.execute(
          event.movieDetail.id,
        );
        emit(
          WatchlistStatusMovieState(status, message),
        );
      },
    );

    on<RemoveWatchlistMovie>(
      (event, emit) async {
        final result = await removeWatchlist.execute(
          event.movieDetail,
        );
        String message = '';

        result.fold(
          (failure) => message = failure.message,
          (succes) => message = successMessageRemoveWatchlist,
        );

        final status = await getWatchlistStatus.execute(
          event.movieDetail.id,
        );
        emit(
          WatchlistStatusMovieState(status, message),
        );
      },
    );

    on<LoadWatchlistStatus>(
      (event, emit) async {
        final result = await getWatchlistStatus.execute(event.id);
        emit(WatchlistStatusMovieState(result, ''));
      },
    );
  }
}
