part of 'popular_list_bloc.dart';

abstract class PopularListEvent extends Equatable {
  const PopularListEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMovie extends PopularListEvent {
  @override
  List<Object> get props => [];
}
