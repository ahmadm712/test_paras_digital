part of 'watchlist_status_movie_bloc.dart';

class WatchlistStatusMovieState extends Equatable {
  final bool status;
  final String message;
  const WatchlistStatusMovieState(this.status, this.message);

  @override
  List<Object> get props => [status, message];
}
