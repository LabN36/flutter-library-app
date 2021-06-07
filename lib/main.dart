import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/authui/loading.dart';
import 'package:flutter_library_app/authui/login.dart';
import 'package:flutter_library_app/authui/otp.dart';
import 'package:flutter_library_app/bloc/config.dart';
import 'package:flutter_library_app/bloc/connection.dart';
import 'package:flutter_library_app/bloc/counter.dart';
import 'package:flutter_library_app/bloc/user.dart';
import 'package:flutter_library_app/model/book.dart';
import 'package:flutter_library_app/model/genre.dart';
import 'package:flutter_library_app/model/userconfig.dart';

import 'package:flutter_library_app/libraryui/book-add-widget.dart';
import 'package:flutter_library_app/libraryui/book-detail-widget.dart';
import 'package:flutter_library_app/libraryui/book-list-widget.dart';
import 'package:flutter_library_app/libraryui/genre-widget.dart';
import 'package:flutter_library_app/util.dart';
import 'bloc/library.dart';

void main() async {
  // HttpOverrides.global = new DevHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', ''), Locale('hi', 'IN')],
        path: 'translations',
        fallbackLocale: Locale('en', ''),
        child: RootWidget()),
  );
}

Future initializeApp() async {
  var prefs = await init();
  var response = await initData(prefs);
  return response;
}

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = PageCubit(0);
    var pageController = new PageController(initialPage: 0);
    return FutureBuilder(
        future: initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            UserState userState = snapshot.data["userState"];
            UserConfig userConfig = snapshot.data['userConfig'];
            ConfigBloc _configBloc = new ConfigBloc(ConfigState(userConfig));

            List<Genre> genreList = snapshot.data['genreList'];
            Map<String, List<Book>> bookListMap = snapshot.data['bookListMap'];
            var connectionBloc = ConnectionBloc(Connectivity());
            LibraryBloc _libraryBloc = LibraryBloc(LibraryState(
                genreList: genreList,
                userState: userState,
                bookMap: bookListMap));
            print('[RootWidget]:  ${userState.authState}');
            return MultiBlocProvider(
                providers: [
                  BlocProvider<LibraryBloc>(
                    create: (context) => _libraryBloc,
                  ),
                  BlocProvider<UserBloc>(
                    create: (BuildContext context) => UserBloc(
                        userState: userState,
                        configBloc: _configBloc,
                        libraryBloc: _libraryBloc),
                  ),
                  BlocProvider<ConfigBloc>(
                      create: (BuildContext tabBuildContext) {
                    return _configBloc;
                  }),
                  BlocProvider<ConnectionBloc>(create: (BuildContext context) {
                    return connectionBloc;
                  })
                ],
                child:
                    BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                  if (state.authState == AuthState.authenticated) {
                    print('[RootWidget]: Returning ProfileWidget');
                    // return ProfileWidget(state);
                    return MaterialApp(
                      home: GenreWidget(genreList),
                      routes: {
                        '/login': (context) => LoginWidget(),
                        '/otp': (context) => OTPWidget(),
                        '/booklist': (context) => BookListWidget(),
                        '/genrelist': (context) => GenreWidget(genreList),
                        '/bookdetail': (context) => BookDetailWidget(),
                        '/bookadd': (context) => BookAddWidget()
                      },
                    );
                  } else {
                    print('[RootWidget]: User Not Authenticated');
                    // TODO: show landing page, login, otp pages
                    return MaterialApp(
                      debugShowMaterialGrid: false,
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: context.locale,
                      debugShowCheckedModeBanner: false,
                      home: GenreWidget(genreList),
                      routes: {
                        '/login': (context) => LoginWidget(),
                        '/otp': (context) => OTPWidget(),
                        '/booklist': (context) => BookListWidget(),
                        '/genrelist': (context) => GenreWidget(genreList),
                        '/bookdetail': (context) => BookDetailWidget(),
                        '/bookadd': (context) => BookDetailWidget()
                      },
                    );
                  }
                }));
          } else {
            //TODO: show loading
            print('[RootWidget]: still Loading Data');
            return LoadingWidget();
          }
        });
  }
}
