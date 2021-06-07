import 'comment.dart';
import 'note.dart';

class Book {
  String id;
  String name;
  String description;
  String gid;
  String genre;
  bool isFav;
  List<Comment> comments;
  List<Note> notes;
  Book({id, name, description, genre, gid, isFav, comments, notes}) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.gid = gid;
    this.genre = genre;
    this.isFav = isFav == 'true' ? true : false;
    this.comments = comments ?? [];
    this.notes = notes ?? [];
  }
}
