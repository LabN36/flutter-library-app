import 'book.dart';

class Genre {
  String id;
  String name;
  // String booksCound;
  bool isFav;
  List<Book> bookList;
  Genre({id, name, isFav, bookList}) {
    this.id = id;
    this.name = name;
    this.isFav = isFav == 'true' ? true : false;
    this.bookList = bookList ?? [];
  }
}
