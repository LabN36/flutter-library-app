import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/bloc/library.dart';
import 'package:flutter_library_app/bloc/user.dart';
import 'package:flutter_library_app/model/book.dart';

class BookListWidget extends StatefulWidget {
  BookListWidget({Key key}) : super(key: key);
  // List<Book> genreList = <Book>[];
  @override
  _BookListWidgetState createState() {
    // genreList.add(Book(id: '1', name: 'First'));
    // genreList.add(Book(id: '2', name: 'Second'));
    // genreList.add(Book(id: '3', name: 'thid'));
    // genreList.add(Book(id: '4', name: 'Four'));
    // genreList.add(Book(id: '5', name: 'Five'));
    return _BookListWidgetState();
  }
}

class _BookListWidgetState extends State<BookListWidget> {
  List<Book> bookList = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, library) {
        if (library.selectedGenre != null) {
          bookList = (library.bookMap[library.selectedGenre.id] ?? []);
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('${library.selectedGenre?.name} genre books'),
            ),
            body: Column(
              children: [
                bookList.length == 0
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('No Books available, please add one.'),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${bookList.length} books found.'),
                          ),
                        ],
                      ),
                Flexible(
                  child: ListView.builder(
                    itemCount: bookList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Book book = bookList[index];
                      return ListTile(
                        trailing: library.userState.authState ==
                                AuthState.authenticated
                            ? IconButton(
                                color: book.isFav == true
                                    ? Colors.red
                                    : Colors.black,
                                icon: Icon(Icons.favorite),
                                onPressed: () {
                                  print('[add book favorite]');
                                  BlocProvider.of<LibraryBloc>(context).add(
                                      AddBookFavouriteEvent(
                                          bid: book.id,
                                          uid: library.userState.userid,
                                          gid: book.gid,
                                          isFav: !book.isFav));
                                })
                            : Text(''),
                        title: Text('Book Name: ${bookList[index].name}'),
                        onTap: () {
                          BlocProvider.of<LibraryBloc>(context)
                              .add(SelectedBookEvent(book: book));
                          Navigator.pushNamed(context, '/bookdetail');
                        },
                      );
                    },
                  ),
                ),
                library.userState.authState == AuthState.authenticated
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/bookadd');
                                },
                                child: Text('Add Book'))),
                      )
                    : Text('')
              ],
            ),
            // ]),
          ),
        );
      },
    );
  }
}
