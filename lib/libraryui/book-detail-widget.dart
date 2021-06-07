import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/bloc/library.dart';
import 'package:flutter_library_app/bloc/user.dart';
import 'package:flutter_library_app/model/comment.dart';
import 'package:flutter_library_app/model/note.dart';

class BookDetailWidget extends StatefulWidget {
  BookDetailWidget({Key key}) : super(key: key);

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetailWidget> {
  TextEditingController bookCommentController = TextEditingController();
  TextEditingController bookNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, user) {
      return BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, library) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              title: Text('Book Detail'),
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Book Name: ${library.selectedBook.name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Book Description ${library.selectedBook.description}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Book Comments',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: library.selectedBook.comments.length,
                      // library.genreMap[library.selectedGenre.id]
                      itemBuilder: (BuildContext context, int index) {
                        Comment comment = library.selectedBook.comments[index];
                        return ListTile(
                          title: Text('${comment.comment}'),
                        );
                      }),
                ),
                user.authState == AuthState.authenticated
                    ? TextField(
                        controller: bookCommentController,
                        decoration: InputDecoration(hintText: 'Add Comment'),
                      )
                    : Text(''),
                user.authState == AuthState.authenticated
                    ? ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<LibraryBloc>(context).add(
                              AddBookCommentEvent(
                                  bid: library.selectedBook.id,
                                  comment: bookCommentController.text,
                                  uid: library.userState.userid));
                          bookCommentController.clear();
                        },
                        child: Text('Comment'))
                    : Text(''),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Book Notes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: library.selectedBook.notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        Note note = library.selectedBook.notes[index];
                        return ListTile(
                          title: Text('${note.note}'),
                        );
                      }),
                ),
                user.authState == AuthState.authenticated
                    ? TextField(
                        controller: bookNoteController,
                        decoration: InputDecoration(hintText: 'Add Note'),
                      )
                    : Text(''),
                user.authState == AuthState.authenticated
                    ? ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<LibraryBloc>(context).add(
                              AddBookNoteEvent(
                                  bid: library.selectedBook.id,
                                  note: bookNoteController.text,
                                  uid: library.userState.userid));
                          bookCommentController.clear();
                        },
                        child: Text('Note'))
                    : Text(''),
              ],
            ),
          ));
        },
      );
    });
  }
}
