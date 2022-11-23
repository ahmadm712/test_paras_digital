import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paras_digital_test/common/constants.dart';
import 'package:paras_digital_test/presentation/bloc/auth/auth_bloc.dart';
import 'package:paras_digital_test/presentation/pages/home_movie_page.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  //....
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in With Google'),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeMoviePage()));
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UnAuthenticated) {
              // return Center(child: //...)

            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lets Login ',
                  style: kHeading6.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(GoogleSignInRequested());
                      },
                      icon: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                        height: 100,
                        width: 100,
                      )),
                ),
                const SizedBox(
                  height: 4,
                ),
                Center(
                  child: Text(
                    'Press this button',
                    style: kHeading6.copyWith(fontSize: 10),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
