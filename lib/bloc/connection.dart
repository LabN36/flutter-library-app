import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityState {
  String name;
  ConnectivityState(name) {
    this.name = name;
  }
}

abstract class AbstractConnectionEvent {}

class ConnectionEvent extends AbstractConnectionEvent {
  ConnectivityResult result;
  ConnectionEvent(this.result);
}

class ConnectionBloc extends Bloc<AbstractConnectionEvent, ConnectivityState> {
  Connectivity connectivity;

  ConnectionBloc(connectivity) : super(ConnectivityState('mobile')) {
    this.connectivity = connectivity;
    this.connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      this.add(ConnectionEvent(result));
    });
  }
  @override
  Stream<ConnectivityState> mapEventToState(
      AbstractConnectionEvent event) async* {
    if (event is ConnectionEvent) {
      print('[Change Event] ${event.result}');
      switch (event.result) {
        case ConnectivityResult.mobile:
          yield ConnectivityState('mobile');
          break;
        case ConnectivityResult.none:
          yield ConnectivityState('none');
          break;
        case ConnectivityResult.wifi:
          yield ConnectivityState('wifi');
          break;
        default:
          yield ConnectivityState('none');
          break;
      }
    } else {
      print('[Other Event]');
      yield ConnectivityState('none');
    }
  }
}
