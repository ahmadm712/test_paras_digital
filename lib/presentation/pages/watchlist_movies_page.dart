import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paras_digital_test/common/constants.dart';
import 'package:paras_digital_test/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:paras_digital_test/presentation/widgets/movie_card_list.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({Key? key}) : super(key: key);

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistMovieBloc>().add(FetchWatchListMovie()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(FetchWatchListMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Watchlist Movie'),
      ),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: CachedNetworkImage(
                            imageUrl: user!.photoURL!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Text(
                        snapshot.data!.email!,
                        style: kHeading6,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Watchlist Movie',
                      style: kHeading6.copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
                      builder: (context, state) {
                        print(state);
                        if (state is WatchlistMovieLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is WatchlistMovieHasData) {
                          if (state.result.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final movie = state.result[index];
                                return MovieCard(movie);
                              },
                              itemCount: state.result.length,
                            );
                          } else {
                            return const Center(
                              key: Key('error_message'),
                              child: Text(
                                'No Watchlist Movie Lets Add it',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        } else if (state is WatchlistMovieError) {
                          return Center(
                            key: const Key('error_message'),
                            child: Text(state.message),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
