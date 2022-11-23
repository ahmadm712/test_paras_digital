import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paras_digital_test/domain/entities/movie.dart';
import 'package:paras_digital_test/domain/usecases/movie/get_popular_movies.dart';

part 'popular_list_event.dart';
part 'popular_list_state.dart';

class PopularListBloc extends Bloc<PopularListEvent, PopularListState> {
  GetPopularMovies getPopularMovies;
  PopularListBloc(this.getPopularMovies) : super(PopularListEmpty()) {
    int page = 1;
    on<FetchPopularMovie>((event, emit) async {
      if (state.hasReachedMaximum) {
        return;
      }
      emit(PopularListLoading(state.movie, state is PopularListEmpty));

      await getPopularMovies.execute(page.toString()).then((result) {
        page++;
        return result.fold(
            (failure) => emit(
                  PopularListError(message: failure.message),
                ), (data) {
          log(page.toString());
          final movies = [...state.movie, ...data];
          final hasReachedMaximum = data.isEmpty;
          return emit(
            PopularListHasData(
                hasReachedMaximum: hasReachedMaximum, result: movies),
          );
        });
      });
    });
  }
}
