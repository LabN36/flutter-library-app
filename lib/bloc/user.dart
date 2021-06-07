import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/bloc/config.dart';
import 'package:flutter_library_app/bloc/library.dart';
import 'package:flutter_library_app/model/userconfig.dart';
import 'package:flutter_library_app/util.dart';

class UserAuthAPIResponse {
  bool success;
  String userid;
  String jwt;
  bool isError;
  String message;
  UserAuthAPIResponse({this.userid, this.success, this.jwt});

  UserAuthAPIResponse.fromJson(Map<String, dynamic> json)
      : userid = json['body']['userid'],
        success = json['body']['success'],
        jwt = json['body']['jwt'],
        isError = json['body']['isError'] ?? false,
        message = json['body']['message'] ?? '';
}

class UserAuthEvent {}

class Auth extends UserAuthEvent {
  UserAuthAPIResponse user;
  Auth(this.user);
}

class UnAuth extends UserAuthEvent {}

class Loading extends UserAuthEvent {
  String phone;
  Loading({this.phone});
}

class WrongOTP extends UserAuthEvent {}

class SetAuthTokenEvent extends UserAuthEvent {
  String verificationId;
  SetAuthTokenEvent(this.verificationId);
}

class SetOtpEvent extends UserAuthEvent {
  String otp;
  SetOtpEvent(this.otp);
}

enum AuthState { loading, unknown, authenticated, unauthenticated, wrongotp }

class UserState {
  AuthState authState;
  String phone;
  String verId;
  String otp;
  String jwt;
  String userid;
  UserConfig userConfig;
  UserState(
      {this.verId,
      this.authState,
      this.otp,
      this.phone,
      this.jwt,
      this.userid,
      this.userConfig});
}

class UserBloc extends Bloc<UserAuthEvent, UserState> {
  UserState userState;
  ConfigBloc configBloc;
  // UserBloc UserBloc;
  LibraryBloc libraryBloc;
  UserBloc({userState, configBloc, libraryBloc}) : super(userState) {
    this.userState = userState;
    this.configBloc = configBloc;
    this.libraryBloc = libraryBloc;
  }

  @override
  Stream<UserState> mapEventToState(UserAuthEvent event) async* {
    if (event is SetAuthTokenEvent) {
      print('[SetAuthTokenEvent Event]');
      String verificationId = event.verificationId;
      print(verificationId);
      yield UserState(
          userid: verificationId,
          phone: state.phone,
          userConfig: state.userConfig,
          verId: verificationId,
          authState: AuthState.loading,
          otp: '');
    } else if (event is Auth) {
      print('[Finally Auth]');
      print(event.user.jwt);
      setJWT(this.configBloc.state.userConfig.prefs, event.user.jwt);
      yield UserState(
          phone: state.phone,
          userConfig: state.userConfig,
          verId: state.verId,
          jwt: event.user.jwt,
          userid: event.user.userid,
          authState: AuthState.authenticated,
          otp: state.otp);
      this.libraryBloc.add(RefreshLibraryEvent(uid: event.user.userid));
    } else if (event is UnAuth) {
      print('[Logging Out]');
      this.configBloc.state.userConfig.prefs.remove('userJWT');
      yield UserState(
          verId: state.verId,
          authState: AuthState.unauthenticated,
          otp: state.otp);
    } else if (event is Loading) {
      //  != null ? event.phone : ''
      yield UserState(
          userConfig: state.userConfig,
          userid: state.userid,
          phone: event.phone,
          verId: state.verId,
          authState: AuthState.loading,
          otp: state.otp);
    } else if (event is WrongOTP) {
      yield UserState(
          phone: state.phone,
          userConfig: state.userConfig,
          userid: state.userid,
          verId: state.verId,
          authState: AuthState.wrongotp,
          otp: state.otp);
    } else {
      print('[Else Event]');
    }
  }

  @override
  Future<void> close() {
    // this.UserBloc.close();
    return super.close();
  }
}
