import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/bloc/library.dart';
import 'package:flutter_library_app/bloc/user.dart';
import 'package:flutter_library_app/main.dart';

class BookAddWidget extends StatefulWidget {
  BookAddWidget({Key key}) : super(key: key);

  @override
  _BookAddWidgetState createState() => _BookAddWidgetState();
}

class _BookAddWidgetState extends State<BookAddWidget> {
  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookDescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(builder: (context, library) {
      return BlocBuilder<UserBloc, UserState>(builder: (context, user) {
        return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: Text('Add Book'),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Genre: ${library.selectedGenre.name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: bookNameController,
                        decoration:
                            InputDecoration(hintText: 'Enter Book Name'),
                      ),
                      TextField(
                        controller: bookDescriptionController,
                        decoration:
                            InputDecoration(hintText: 'Enter Book Description'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<LibraryBloc>(context).add(
                                      AddBookEvent(
                                          gid: library.selectedGenre.id,
                                          uid: user.userid,
                                          bookName: bookNameController.text,
                                          description:
                                              bookDescriptionController.text));
                                  Navigator.pop(context);
                                  // Navigator.pushNamed(context, '/login');
                                },
                                child: Text('Add Book'))),
                      )
                    ],
                  ),
                )));
      });
    });
  }
}
