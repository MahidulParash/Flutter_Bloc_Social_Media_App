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
              backgroundColor: Theme.of(context).colorScheme.secondary,
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
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Welcome ${state.user!.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<GetPostBloc>().add(GetPosts());
        },
        child: BlocBuilder<GetPostBloc, GetPostState>(
          builder: (context, state) {
            if (state is GetPostSuccess) {
              return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, int i) {
                    state.posts
                        .sort((a, b) => b.createAt.compareTo(a.createAt));
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        // height: 400,
                        // color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.posts[i].myUser.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(state.posts[i].createAt),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        DateFormat('hh:mm a')
                                            .format(state.posts[i].createAt),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                // color: Colors.amber,
                                child: Text(
                                  state.posts[i].post,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (state is GetPostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text("An error has occured"),
              );
            }
          },
        ),
      ),
    );
  }
}
