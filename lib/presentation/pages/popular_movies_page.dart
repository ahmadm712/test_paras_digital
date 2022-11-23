import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paras_digital_test/presentation/bloc/movie_list/popular_list/popular_list_bloc.dart';
import 'package:paras_digital_test/presentation/widgets/movie_card_list.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularListBloc>().add(
            FetchPopularMovie(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PopularListBloc, PopularListState>(
            builder: (context, state) {
              if (state is PopularListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularListHasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final movie = state.result[index];
                    return MovieCard(movie);
                  },
                  itemCount: state.result.length,
                );
              } else if (state is PopularListError) {
                return Center(
                  key: const Key('error_message'),
                  child: Text(state.message),
                );
              } else {
                return Container();
              }
            },
          )),
    );
  }
}
