part of 'watchlist_status_movie_bloc.dart';

abstract class WatchlistStatusMovieEvent extends Equatable {
  const WatchlistStatusMovieEvent();

  @override
  List<Object> get props => [];
}

class AddWatchlistMovie extends WatchlistStatusMovieEvent {
  final MovieDetail movieDetail;

  const AddWatchlistMovie(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class RemoveWatchlistMovie extends WatchlistStatusMovieEvent {
  final MovieDetail movieDetail;

  const RemoveWatchlistMovie(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class LoadWatchlistStatus extends WatchlistStatusMovieEvent {
  final int id;
  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
