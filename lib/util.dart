import 'dart:async';

import 'package:flutter_library_app/bloc/user.dart';
import 'package:flutter_library_app/db/library.dart';
import 'package:flutter_library_app/model/book.dart';
import 'package:flutter_library_app/model/genre.dart';
import 'package:flutter_library_app/model/userconfig.dart';
import 'package:jose/jose.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortid/shortid.dart';
import 'package:sqflite/sqflite.dart';

Future<SharedPreferences> init() async {
  shortid.characters(
      '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\$_');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

getUserJWT(prefs) async {
  String jwt = prefs.getString('userJWT');
  // return jwt;
  if (jwt != null) {
    return jwt;
  } else {
    return jwt;
  }
}

setJWT(prefs, jwt) async {
  print('[setJWT] $jwt');
  prefs.setString('userJWT', jwt);
}

getUserID(prefs) async {
  String jwt = prefs.getString('userJWT');
  if (jwt != null) {
    var user = new JsonWebToken.unverified(jwt);
    if (user != null && user.claims != null && user.claims['userid'] != null) {
      return user.claims['userid'];
    } else {
      print('Token Not Valid');
    }
  }
}

getDBVersion(prefs) async {
  int dbVersion = prefs.getInt('dbVersion');
  if (dbVersion != null) {
    return dbVersion;
  } else {
    return 0;
  }
}

Future<List<String>> getTableList(db) async {
  String sql = "SELECT name FROM sqlite_master WHERE type='table';";
  List<Map> tableList = await db.rawQuery(sql);
  List<String> list = [];
  if (tableList.length > 0) {
    for (var i = 0; i < tableList.length; i++) {
      if (tableList[i]['name'] != 'android_metadata')
        list.add(tableList[i]['name']);
    }
  }
  return list;
}

Future initData(prefs) async {
  var userJWT = await getUserJWT(prefs);
  var userId = await getUserID(prefs);
  var dbVersion = await getDBVersion(prefs);

  var databasesPath = await getDatabasesPath() + '/' + 'library';
  print(databasesPath);

  var db = await openDatabase(databasesPath, version: 1);
  List<String> tableList = await getTableList(db);
  LibraryDB library = LibraryDB(db);
  if (tableList.length == 0) {
    await library.boot();
  }

  var res = await library.listGenre(uid: userId ?? '');
  List<Genre> genreList = [];
  Map<String, List<Book>> bookListMap = {};

  genreList = res['genreList'];
  bookListMap = res['bookListMap'];
  UserConfig userConfig = UserConfig(
      prefs: prefs,
      db: db,
      userJWT: userJWT,
      userId: userId,
      dbVersion: dbVersion);
  UserState userState;

  if (userConfig.userId != null) {
    userState = UserState(
        authState: AuthState.authenticated,
        jwt: userConfig.userJWT,
        userid: userConfig.userId,
        verId: '',
        phone: '',
        otp: '',
        userConfig: userConfig);
  } else {
    //TODO: set mock data for testing purpose
    userState = UserState(
        authState: AuthState.unauthenticated,
        phone: '',
        // verId: '',
        // otp: '',
        // jwt: '',
        // userid: '',
        userConfig: userConfig);
  }
  Map<String, dynamic> initData = {
    'userConfig': userConfig,
    'genreList': genreList,
    'bookListMap': bookListMap,
    'userState': userState
  };
  return initData;
}
