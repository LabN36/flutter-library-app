import 'package:flutter_library_app/model/book.dart';
import 'package:flutter_library_app/model/comment.dart';
import 'package:flutter_library_app/model/genre.dart';
import 'package:flutter_library_app/model/note.dart';
import 'package:shortid/shortid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_library_app/main.dart';

class LibraryDB {
  Database db;
  LibraryDB(this.db);
  final String genre = 'genre';
  final String book = 'bookv1';
  final String comment = 'comment';
  final String note = 'note';
  final String genrefav = 'genrefav';
  final String bookfav = 'bookfavv1';
  boot() async {
    print('[Library Boot]');
    await this.createBookTable();
    await this.createGenreTable();
    await this.createCommentTable();
    await this.createNoteTable();
    await this.createBookFavTable();
    await this.createGenreFavouriteTable();
    await this.createSampleGenre();
  }

  // fields = sn,epoc,genreid,genre
  createGenreTable() async {
    print('[createGenreTable]');
    var createTableQuery =
        'CREATE TABLE $genre (sn INTEGER PRIMARY KEY AUTOINCREMENT, epoc INT(12), genreid TEXT, genre TEXT);';
    print(createTableQuery);
    List<Map> response = await db.rawQuery(createTableQuery);
    print(response);
  }

  // fields = sn,epoc,genreid,userid,isfav
  createGenreFavouriteTable() async {
    print('[createGenreFavouriteTable]');
    var createTableQuery =
        'CREATE TABLE $genrefav (sn INTEGER PRIMARY KEY AUTOINCREMENT, epoc INT(12), genreid TEXT, userid TEXT, isfav BOOLEAN);';
    print(createTableQuery);
    List<Map> response = await db.rawQuery(createTableQuery);
    print(response);
  }

  // fields = sn,epoc,genreid,bookid,name,description,userid
  createBookTable() async {
    print('[createBookTable]');
    var createTableQuery =
        'CREATE TABLE $book (sn INTEGER PRIMARY KEY AUTOINCREMENT, epoc INT(12), genreid TEXT,bookid TEXT,name TEXT, description TEX, userid TEXT);';
    print(createTableQuery);
    List<Map> response = await db.rawQuery(createTableQuery);
    print(response);
  }

  // fields = sn,epoc,genreid,userid,bookid,isfav
  createBookFavTable() async {
    print('[createBookFavTable]');
    var createTableQuery =
        'CREATE TABLE $bookfav (sn INTEGER PRIMARY KEY AUTOINCREMENT, epoc INT(12), genreid TEXT, userid TEXT, bookid TEXT, isfav BOOLEAN);';
    print(createTableQuery);
    List<Map> response = await db.rawQuery(createTableQuery);
    print(response);
  }

  // fields = sn,epoc,commentid,userid,bookid,comment
  createCommentTable() async {
    print('[createCommentTable]');
    var createTableQuery =
        'CREATE TABLE $comment (sn INTEGER PRIMARY KEY AUTOINCREMENT, epoc INT(12), commentid TEXT, userid TEXT, bookid TEXT, comment TEXT);';
    print(createTableQuery);
    List<Map> response = await db.rawQuery(createTableQuery);
    print(response);
  }

  // fields = sn,epoc,noteid,userid,bookid,note
  createNoteTable() async {
    print('[createNoteTable]');
    var createTableQuery =
        'CREATE TABLE $note (sn INTEGER PRIMARY KEY AUTOINCREMENT, epoc INT(12), noteid TEXT, userid TEXT, bookid TEXT, note TEXT);';
    print(createTableQuery);
    List<Map> response = await db.rawQuery(createTableQuery);
    print(response);
  }

  createGenre(String genreName) async {
    print('[createGenre]');
    var now = DateTime.now().toUtc();
    String genreid = shortid.generate();
    var createItemQuery =
        "INSERT INTO genre (epoc,genreid,genre) VALUES (${now.microsecondsSinceEpoch},'$genreid','$genreName');";
    print(createItemQuery);
    var response = await db.rawQuery(createItemQuery);
    print(response);
  }

  creatBook(String bookName, String description, String gid, String uid) async {
    print('[creatBook]');
    var now = DateTime.now().toUtc();
    String bookid = shortid.generate();
    var createItemQuery =
        "INSERT INTO $book (epoc,genreid,bookid,name,description,userid) VALUES (${now.microsecondsSinceEpoch},'$gid','$bookid','$bookName','$description','$uid');";
    print(createItemQuery);
    var response = await db.rawQuery(createItemQuery);
    print(response);
  }

  creatComment(String comment, String uid, String bid) async {
    print('[creatComment]');
    var now = DateTime.now().toUtc();
    String commentid = shortid.generate();
    var createItemQuery =
        "INSERT INTO ${this.comment} (epoc,commentid,comment,userid,bookid) VALUES (${now.microsecondsSinceEpoch},'$commentid','$comment','$uid','$bid');";
    print(createItemQuery);
    var response = await db.rawQuery(createItemQuery);
    print(response);
  }

  creatNote(String note, String uid, String bid) async {
    print('[creatComment]');
    var now = DateTime.now().toUtc();
    String noteid = shortid.generate();
    var createItemQuery =
        "INSERT INTO ${this.note} (epoc,noteid,note,userid,bookid) VALUES (${now.microsecondsSinceEpoch},'$noteid','$note','$uid','$bid');";
    print(createItemQuery);
    var response = await db.rawQuery(createItemQuery);
    print(response);
  }

  listGenre({String uid}) async {
    print('[listGenre]');
    List<Genre> genreList = [];
    Map<String, String> favGenreMap = {};
    Map<String, List<Book>> bookListMap = {};
    Map<String, Book> bookMap = {};
    try {
      var createItemQuery = "SELECT * FROM $genre;";
      if (uid != null) {
        favGenreMap = await listFavGenreMap(uid);
      }
      var bookRes = await listBook(uid: uid);
      bookListMap = bookRes['bookListMap'];
      bookMap = bookRes['bookMap'];
      var response = await db.rawQuery(createItemQuery);
      for (var i = 0; i < response.length; i++) {
        var genre = response[i];
        genreList.add(Genre(
            id: genre['genreid'],
            name: genre['genre'],
            isFav: favGenreMap[genre['genreid']],
            bookList: bookListMap[genre['genreid']]));
      }
    } catch (e) {
      print(e);
    }
    return {
      'genreList': genreList,
      'bookListMap': bookListMap,
      'bookMap': bookMap
    };
  }

  listBook({String uid, String gid}) async {
    print('[listBook]');
    Map<String, List<Book>> bookListMap = {};
    Map<String, Book> bookMap = {};
    Map<String, String> favGenreMap = {};
    Map<String, List<Comment>> commentMap = {};
    Map<String, List<Note>> noteMap = {};
    String bookListQuery;
    try {
      bookListQuery = "SELECT * FROM $book;";
      if (uid != null) {
        favGenreMap = await listFavBookMap(uid);
        noteMap = await listNote(uid);
      }
      commentMap = await listComment();
      var response = await db.rawQuery(bookListQuery);
      for (var i = 0; i < response.length; i++) {
        var item = response[i];
        String bid = item['bookid'];
        print('[$bid]');
        Book book = Book(
            id: bid,
            name: item['name'],
            description: item['description'],
            gid: item['genreid'],
            genre: item['genreid'],
            isFav: favGenreMap[bid],
            comments: commentMap[bid],
            notes: noteMap[bid]);
        bookMap[bid] = book;
        bookListMap[book.genre] = bookListMap[book.genre] ?? [];
        bookListMap[book.genre].add(book);
      }
    } catch (e) {
      print(e);
    }
    print(bookListMap);
    return {'bookMap': bookMap, 'bookListMap': bookListMap};
  }

  listComment() async {
    print('[listComment]');
    Map<String, List<Comment>> commentMap = {};
    String commentListQuery = "SELECT * FROM $comment;";
    var response = await db.rawQuery(commentListQuery);
    for (var i = 0; i < response.length; i++) {
      var comment = response[i];
      commentMap[comment['bookid']] = commentMap[comment['bookid']] ?? [];
      commentMap[comment['bookid']].add(Comment(
          id: comment['commentid'],
          bid: comment['bookid'],
          comment: comment['comment']));
    }
    return commentMap;
  }

  listNote(String uid) async {
    print('[listNote]');
    Map<String, List<Note>> noteMap = {};
    String commentListQuery = "SELECT * FROM $note WHERE userid='$uid';";
    var response = await db.rawQuery(commentListQuery);
    for (var i = 0; i < response.length; i++) {
      var note = response[i];
      noteMap[note['bookid']] = noteMap[note['bookid']] ?? [];
      noteMap[note['bookid']].add(
          Note(id: note['noteid'], bid: note['bookid'], note: note['note']));
    }
    return noteMap;
  }

  listFavGenreMap(String uid) async {
    print('[listFavGenre]');
    // List<Genre> favGenreList = [];
    Map<String, String> favGenreMap = {};
    var createItemQuery = "SELECT * FROM $genrefav WHERE userid='$uid';";
    print(createItemQuery);
    try {
      var response = await db.rawQuery(createItemQuery);
      for (var i = 0; i < response.length; i++) {
        var genre = response[i];
        // print(genre);
        favGenreMap[genre['genreid']] = genre['isfav']; // ?? '';
        // favGenreList.add(Genre(id: genre['genreid'], isFav: genre['isfav']));
      }
    } catch (e) {
      print(e);
    }
    print(favGenreMap);
    return favGenreMap;
  }

  listFavBookMap(String uid) async {
    print('[listFavBookMap]');
    // List<Genre> favGenreList = [];
    Map<String, String> favBookMap = {};
    var createItemQuery = "SELECT * FROM $bookfav WHERE userid='$uid';";
    print(createItemQuery);
    try {
      var response = await db.rawQuery(createItemQuery);
      for (var i = 0; i < response.length; i++) {
        var book = response[i];
        favBookMap[book['bookid']] = book['isfav']; // ?? '';
        // favGenreList.add(Genre(id: genre['genreid'], isFav: genre['isfav']));
      }
    } catch (e) {
      print(e);
    }
    print(favBookMap);
    return favBookMap;
  }

  updateGenre() {}
  delteGenre() {}

  addBookFav(String uid, String gid, String bid, bool isFav) async {
    print('[addBookFav]');
    // sn,epoc,genreid,userid,bookid,isfav
    // TODO:check if genre is new then create the genre and then set fav book
    String query =
        "SELECT * FROM $bookfav WHERE genreid='$gid' AND userid='$uid' AND bookid='$bid'";
    print(query);
    var response = await db.rawQuery(query);
    print(response);
    if (response != null && response.length > 0) {
      //update
      var createItemQuery =
          "UPDATE $bookfav SET isfav='$isFav' WHERE genreid='$gid' AND userid='$uid' AND bookid='$bid';";
      print(createItemQuery);
      var response = await db.rawQuery(createItemQuery);
      print(response);
    } else {
      //insert
      var now = DateTime.now().toUtc();
      var createItemQuery =
          "INSERT INTO $bookfav (epoc,bookid,genreid,userid,isfav) VALUES (${now.microsecondsSinceEpoch},'$bid','$gid','$uid','$isFav');";
      print(createItemQuery);
      var response = await db.rawQuery(createItemQuery);
      print(response);
    }
  }

  addGenreFav(String gid, String uid, bool isFav) async {
    //TODO:implement stored procedure later
    print('[addGenreFav]');
    String query =
        "SELECT * FROM $genrefav WHERE genreid='$gid' AND userid='$uid'";
    print(query);
    var response = await db.rawQuery(query);
    print(response);
    if (response != null && response.length > 0) {
      //update
      var createItemQuery =
          "UPDATE $genrefav SET isfav='$isFav' WHERE genreid='$gid' AND userid='$uid';";
      print(createItemQuery);
      var response = await db.rawQuery(createItemQuery);
      print(response);
    } else {
      //insert
      var now = DateTime.now().toUtc();
      var createItemQuery =
          "INSERT INTO $genrefav (epoc,genreid,userid,isfav) VALUES (${now.microsecondsSinceEpoch},'$gid','$uid','$isFav');";
      print(createItemQuery);
      var response = await db.rawQuery(createItemQuery);
      print(response);
    }
  }

  createSampleGenre() async {
    print('[createSampleGenre]');
    for (var i = 0; i < 5; i++) {
      print('[$i]');
      await createGenre('Random $i');
    }
  }
}
