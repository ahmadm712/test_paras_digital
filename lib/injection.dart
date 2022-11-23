import 'package:paras_digital_test/data/datasources/db/database_helper.dart';
import 'package:paras_digital_test/data/datasources/movie_local_data_source.dart';
import 'package:paras_digital_test/data/datasources/movie_remote_data_source.dart';
import 'package:paras_digital_test/data/repositories/movie_repository_impl.dart';
import 'package:paras_digital_test/domain/repositories/auth_repository.dart';
import 'package:paras_digital_test/domain/repositories/movie_repository.dart';
import 'package:paras_digital_test/domain/usecases/movie/get_movie_detail.dart';

import 'package:paras_digital_test/domain/usecases/movie/get_popular_movies.dart';
import 'package:paras_digital_test/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:paras_digital_test/domain/usecases/movie/get_watchlist_status.dart';
import 'package:paras_digital_test/domain/usecases/movie/remove_watchlist.dart';
import 'package:paras_digital_test/domain/usecases/movie/save_watchlist.dart';
import 'package:paras_digital_test/presentation/bloc/auth/auth_bloc.dart';
import 'package:paras_digital_test/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:paras_digital_test/presentation/bloc/movie_detail/watchlist_status_movie/watchlist_status_movie_bloc.dart';
import 'package:paras_digital_test/presentation/bloc/movie_list/popular_list/popular_list_bloc.dart';
import 'package:paras_digital_test/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // Movie Bloc

  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistStatusMovieBloc(
        getWatchlistStatus: locator(),
        removeWatchlist: locator(),
        saveWatchlist: locator()),
  );

  locator.registerFactory(
    () => PopularListBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistMovieBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => AuthBloc(
      locator(),
    ),
  );

  /// Movie use case
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  /// Movie repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(),
  );

  // Movie data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelperMovies>(
      () => DatabaseHelperMovies());

  // external
  locator.registerLazySingleton(() => http.Client());
}
