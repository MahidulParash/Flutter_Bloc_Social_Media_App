import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_crud/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:flutter_bloc_crud/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:flutter_bloc_crud/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_bloc_crud/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_bloc_crud/screens/home/post_screen.dart';
import 'package:intl/intl.dart';
import 'package:post_repository/post_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          if (state.status == MyUserStatus.success) {
            return FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        BlocProvider<CreatePostBloc>(
                      create: (context) => CreatePostBloc(
                          postRepository: FirebasePostRepository()),
                      child: PostScreen(state.user!),
                    ),
                  ),
                );
              },
            );
          } else {
            return FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: Icon(Icons.clear),
              onPressed: null,
            );
          }
        },
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return Row(
                children: [
                  Container(
                    child: Icon(Icons.person),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Welcome ${state.user!.name}'),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(const SignOutRequired());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, int i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                //height: 400,
                //color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Icon(Icons.person),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mahidul'),
                              Text(
                                '27 December, 2023',
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Lorem Ispum',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
