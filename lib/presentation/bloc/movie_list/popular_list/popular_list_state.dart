// ignore_for_file: must_be_immutable

part of 'popular_list_bloc.dart';

abstract class PopularListState extends Equatable {
  PopularListState(
      {this.movie = const <Movie>[], required this.hasReachedMaximum});
  List<Movie> movie;
  bool hasReachedMaximum;
  @override
  List<Object> get props => [movie];
}

class PopularListEmpty extends PopularListState {
  PopularListEmpty() : super(hasReachedMaximum: false);
}

class PopularListLoading extends PopularListState {
  final bool isInitial;
  PopularListLoading(
    final List<Movie> movie,
    this.isInitial,
  ) : super(movie: movie, hasReachedMaximum: false);
}

class PopularListError extends PopularListState {
  final String message;

  PopularListError({required this.message}) : super(hasReachedMaximum: false);

  @override
  List<Object> get props => [message];
}

class PopularListHasData extends PopularListState {
  final List<Movie> result;
  final bool hasReachedMaximum;

  PopularListHasData({
    required this.result,
    required this.hasReachedMaximum,
  }) : super(hasReachedMaximum: hasReachedMaximum, movie: result);

  @override
  List<Object> get props => [result, hasReachedMaximum];
}
