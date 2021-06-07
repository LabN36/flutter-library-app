import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/bloc/user.dart';
import 'package:flutter_library_app/db/library.dart';
import 'package:flutter_library_app/model/book.dart';
import 'package:flutter_library_app/model/genre.dart';

abstract class AppEvent {}

abstract class AppState {}

class RefreshLibraryEvent extends AppEvent {}

class BookEvent extends AppEvent {}

class GenreEvent extends AppEvent {}

class AddBookEvent extends BookEvent {
  String bookName;
  String uid;
  String gid;
  String description;
  AddBookEvent({this.bookName, this.description, this.uid, this.gid});
}

class AddBookCommentEvent extends BookEvent {
  String comment;
  String uid;
  String bid;
  AddBookCommentEvent({this.comment, this.uid, this.bid});
}

class AddBookNoteEvent extends BookEvent {
  String note;
  String uid;
  String bid;
  AddBookNoteEvent({this.note, this.uid, this.bid});
}

class AddBookFavouriteEvent extends BookEvent {
  String uid;
  String gid;
  String bid;
  bool isFav;
  AddBookFavouriteEvent({uid, gid, bid, isFav}) {
    this.uid = uid;
    this.gid = gid;
    this.bid = bid;
    this.isFav = isFav; // == 'true' ? true : false;
  }
}

class SelectedBookEvent extends BookEvent {
  Book book;
  SelectedBookEvent({this.book});
}

class AddGenreFavouriteEvent extends GenreEvent {
  String gid;
  String uid;
  bool isFav;
  AddGenreFavouriteEvent(this.gid, this.uid, this.isFav);
}

class SelectedGenreEvent extends GenreEvent {
  Genre genre;
  SelectedGenreEvent({this.genre});
}

class LibraryState extends AppState {
  List<Genre> genreList;
  Map<String, List<Book>> bookMap;
  Genre selectedGenre;
  Book selectedBook;
  UserState userState;
  LibraryState({genreList, userState, selectedGenre, bookMap, selectedBook}) {
    this.genreList = genreList;
    this.userState = userState;
    this.selectedGenre = selectedGenre;
    this.bookMap = bookMap;
    this.selectedBook = selectedBook;
  }
}

class LibraryBloc extends Bloc<AppEvent, LibraryState> {
  LibraryBloc(LibraryState initialState) : super(initialState);

  @override
  Stream<LibraryState> mapEventToState(AppEvent event) async* {
    if (event is RefreshLibraryEvent) {
      print('[RefreshLibraryEvent]');
      LibraryDB library = LibraryDB(state.userState.userConfig.db);
      var res = await library.listGenre();
      List<Genre> genreList = res['genreList'];
      yield LibraryState(
          genreList: genreList,
          userState: state.userState,
          bookMap: res['bookListMap']);
    }
    if (event is AddBookEvent) {
      print('[Add Book Event]');
      LibraryDB library = LibraryDB(state.userState.userConfig.db);
      library.creatBook(
          event.bookName, event.description, event.gid, event.uid);
      var res = await library.listGenre(uid: event.uid);
      yield LibraryState(
          bookMap: res['bookListMap'],
          genreList: res['genreList'],
          userState: state.userState,
          selectedGenre: state.selectedGenre);
    } else if (event is AddGenreFavouriteEvent) {
      print('[Genre Event]');
      LibraryDB library = LibraryDB(state.userState.userConfig.db);
      await library.addGenreFav(event.gid, event.uid, event.isFav);
      var res = await library.listGenre(uid: event.uid);
      List<Genre> genreList = res['genreList'];
      // yield await library.listGenre(uid:event.uid);
      yield LibraryState(
          genreList: genreList,
          userState: state.userState,
          bookMap: res['bookListMap']);
    } else if (event is AddBookFavouriteEvent) {
      print('[AddBookFavouriteEvent]');
      LibraryDB library = LibraryDB(state.userState.userConfig.db);
      await library.addBookFav(event.uid, event.gid, event.bid, event.isFav);
      var res = await library.listGenre(uid: event.uid);
      List<Genre> genreList = res['genreList'];
      // yield await library.listGenre(event.uid);
      yield LibraryState(
          genreList: genreList,
          userState: state.userState,
          bookMap: res['bookListMap'],
          selectedGenre: state.selectedGenre);
    } else if (event is SelectedGenreEvent) {
      print('[SelectedGenreEvent]');
      yield LibraryState(
          bookMap: state.bookMap,
          genreList: state.genreList,
          userState: state.userState,
          selectedGenre: event.genre);
    } else if (event is SelectedBookEvent) {
      print('[SelectedBookEvent]');
      yield LibraryState(
          bookMap: state.bookMap,
          genreList: state.genreList,
          selectedGenre: state.selectedGenre,
          userState: state.userState,
          selectedBook: event.book);
    } else if (event is AddBookCommentEvent) {
      print('[AddBookCommentEvent]');
      LibraryDB library = LibraryDB(state.userState.userConfig.db);
      await library.creatComment(event.comment, event.uid, event.bid);
      var res = await library.listGenre(uid: event.uid);
      List<Genre> genreList = res['genreList'];
      yield LibraryState(
          genreList: genreList,
          bookMap: res['bookListMap'],
          userState: state.userState,
          selectedBook: res['bookMap'][state.selectedBook.id],
          selectedGenre: state.selectedGenre);
    } else if (event is AddBookNoteEvent) {
      print('[AddBookNoteEvent]');
      LibraryDB library = LibraryDB(state.userState.userConfig.db);
      await library.creatNote(event.note, event.uid, event.bid);
      var res = await library.listGenre(uid: event.uid);
      List<Genre> genreList = res['genreList'];
      yield LibraryState(
          genreList: genreList,
          bookMap: res['bookListMap'],
          userState: state.userState,
          selectedBook: res['bookMap'][state.selectedBook.id],
          selectedGenre: state.selectedGenre);
    }
    print('[Final Construct]');
  }
}
