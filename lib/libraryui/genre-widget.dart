import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/bloc/library.dart';
import 'package:flutter_library_app/bloc/user.dart';
import 'package:flutter_library_app/model/genre.dart';

class GenreWidget extends StatefulWidget {
  GenreWidget(this.genreList, {Key key}) : super(key: key);
  final List<Genre> genreList;
  @override
  _GenreWidgetState createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, library) {
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: Text('Simple Library App'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  print('[saerch]');
                },
              )
            ],
          ),
          body: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(
                      'Genre List',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Text(
                      'Click on genre to get list of books',
                      // style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(
                    library.genreList.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          BlocProvider.of<LibraryBloc>(context).add(
                              SelectedGenreEvent(
                                  genre: library.genreList[index]));
                          Navigator.pushNamed(context, '/booklist');
                        },
                        child: Container(
                          // color: Colors.red,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${library.genreList[index].name}',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Text(
                                    '${library.genreList[index].bookList.length} Books Found'),
                                BlocBuilder<UserBloc, UserState>(
                                  builder: (context, authState) {
                                    if (authState.authState ==
                                        AuthState.authenticated) {
                                      return IconButton(
                                          color: library.genreList[index].isFav
                                              ? Colors.red
                                              : Colors.black,
                                          icon: Icon(Icons.favorite),
                                          onPressed: () {
                                            //set action
                                            BlocProvider.of<LibraryBloc>(
                                                    context)
                                                .add(AddGenreFavouriteEvent(
                                                    library.genreList[index].id,
                                                    authState.userid,
                                                    !library.genreList[index]
                                                        .isFav));
                                            print('[add favorite]');
                                          });
                                    } else {
                                      return Text('');
                                    }
                                  },
                                )
                              ]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<UserBloc, UserState>(builder: (context, authState) {
                if (authState.authState == AuthState.unauthenticated) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text('Login'))),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              context.read<UserBloc>().add(UnAuth());
                              BlocProvider.of<LibraryBloc>(context)
                                  .add(RefreshLibraryEvent());
                              // Navigator.pushNamed(context, '/login');
                            },
                            child: Text('Logout'))),
                  );
                  // return Text('');
                  // return Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: SizedBox(
                  //       width: double.infinity,
                  //       child: ElevatedButton(
                  //           onPressed: () {
                  //             Navigator.pushNamed(context, '/bookadd');
                  //           },
                  //           child: Text('Add Book'))),
                  // );
                }
              })
            ],
          ),
        ));
      },
    );
  }
}
