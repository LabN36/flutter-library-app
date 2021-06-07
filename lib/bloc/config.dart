import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/model/userconfig.dart';

class ConfigState {
  UserConfig userConfig;
  ConfigState(userConfig) {
    this.userConfig = userConfig;
  }
}

class ConfigEvent {
  UserConfig userConfig;
  ConfigEvent(userConfig) {
    this.userConfig = userConfig;
  }
}

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  ConfigBloc(ConfigState initialState) : super(initialState);

  @override
  Stream<ConfigState> mapEventToState(ConfigEvent event) async* {
    if (event is ConfigEvent) {
      print('[ConfigBloc] [mapEventToState]');
      yield ConfigState(event.userConfig);
    }
  }
}
