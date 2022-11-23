// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paras_digital_test/common/constants.dart';
import 'package:paras_digital_test/presentation/bloc/auth/auth_bloc.dart';
import 'package:paras_digital_test/presentation/bloc/movie_list/popular_list/popular_list_bloc.dart';
import 'package:paras_digital_test/presentation/pages/movie_detail_page.dart';
import 'package:paras_digital_test/presentation/pages/sign_in_page.dart';
import 'package:paras_digital_test/presentation/pages/watchlist_movies_page.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      context.read<PopularListBloc>().add(FetchPopularMovie());
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Future.microtask(() {
        context.read<PopularListBloc>().add(FetchPopularMovie());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://images.glints.com/unsafe/glints-dashboard.s3.amazonaws.com/company-logo/bc798fbeb87c2fce1feb449b51ad37cb.png'),
              ),
              accountName: const Text('Paras Digital Test App'),
              accountEmail: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.displayName!.isEmpty
                          ? snapshot.data!.email!
                          : snapshot.data!.displayName!);
                    }
                    return Container();
                  }),
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Profile & Watchlist Movies'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Paras Digital Test App'),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SignIn()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<PopularListBloc, PopularListState>(
          builder: (context, state) {
            if (state is PopularListHasData ||
                state is PopularListLoading && !state.isInitial) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  if (index >= state.movie.length) {
                    return state.hasReachedMaximum
                        ? const Center(
                            child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Has Reach Max'),
                          ))
                        : const Center(
                            child: CircularProgressIndicator(strokeWidth: 0.7),
                          );
                  } else {
                    final movie = state.movie[index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            MovieDetailPage.ROUTE_NAME,
                            arguments: movie.id,
                          );
                        },
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          child: Container(
                            child: CachedNetworkImage(
                              imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                itemCount: state.movie.length + 1,
              );
            } else if (state is PopularListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularListError) {
              return const Text('Failed');
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

// class MovieList extends StatelessWidget {
//   final List<Movie> movies;

//   const MovieList(this.movies, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return;
//   }
// }
