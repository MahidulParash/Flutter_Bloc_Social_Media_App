import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_crud/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:flutter_bloc_crud/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_bloc_crud/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_bloc_crud/screens/authentication/welcome_screen.dart';
import 'package:post_repository/post_repository.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'screens/home/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'S O C I A L',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          background: Colors.grey.shade900,
          primary: Colors.grey.shade800,
          onPrimary: Colors.white,
          secondary: Colors.grey.shade700,
          inversePrimary: Colors.grey.shade300,
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SignInBloc(
                  userRepository:
                      context.read<AuthenticationBloc>().userRepository,
                ),
              ),
              BlocProvider(
                create: (context) => MyUserBloc(
                  myUserRepository:
                      context.read<AuthenticationBloc>().userRepository,
                )..add(GetMyUser(
                    myUserId:
                        context.read<AuthenticationBloc>().state.user!.uid,
                  )),
              ),
              BlocProvider(
                create: (context) =>
                    GetPostBloc(postRepository: FirebasePostRepository())
                      ..add(GetPosts()),
              ),
            ],
            child: const HomeScreen(),
          );
        } else {
          return const WelcomeScreen();
        }
      }),
    );
  }
}
