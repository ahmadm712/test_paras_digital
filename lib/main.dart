import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paras_digital_test/common/constants.dart';
import 'package:paras_digital_test/common/utils.dart';
import 'package:paras_digital_test/firebase_options.dart';
import 'package:paras_digital_test/injection.dart' as di;
import 'package:paras_digital_test/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:paras_digital_test/presentation/bloc/movie_detail/watchlist_status_movie/watchlist_status_movie_bloc.dart';
import 'package:paras_digital_test/presentation/bloc/movie_list/popular_list/popular_list_bloc.dart';
import 'package:paras_digital_test/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:paras_digital_test/presentation/pages/home_movie_page.dart';
import 'package:paras_digital_test/presentation/pages/movie_detail_page.dart';
import 'package:paras_digital_test/presentation/pages/popular_movies_page.dart';
import 'package:paras_digital_test/presentation/pages/sign_in_page.dart';
import 'package:paras_digital_test/presentation/pages/watchlist_movies_page.dart';
import 'package:provider/provider.dart';
import 'presentation/bloc/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Movie Bloc

        BlocProvider(
          create: (_) => di.locator<PopularListBloc>(),
        ),

        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),

        BlocProvider(
          create: (_) => di.locator<WatchlistStatusMovieBloc>(),
        ),

        BlocProvider(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),

        BlocProvider(
          create: (_) => di.locator<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Paras Digital App',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeMoviePage();
            }
            return const SignIn();
          },
        ),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviesPage());

            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case WatchlistMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const WatchlistMoviesPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
