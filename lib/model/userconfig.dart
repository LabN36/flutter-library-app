import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserConfig {
  SharedPreferences prefs;
  Database db;
  String userJWT;
  // String businessId;
  String userId;
  int dbVersion;
  UserConfig({prefs, db, userJWT, userId, dbVersion}) {
    this.prefs = prefs;
    this.db = db;
    this.userJWT = userJWT;
    this.userId = userId;
    this.dbVersion = dbVersion;
  }
  UserConfig.fromJson(userConfig) {
    this.db = userConfig['db'];
    // this.businessId = userConfig['businessId'];
    this.userJWT = userConfig['userJWT'];
    this.dbVersion = userConfig['dbVersion'];
    this.prefs = userConfig['prefs'];
    this.userId = userConfig['userId'];
  }
}
