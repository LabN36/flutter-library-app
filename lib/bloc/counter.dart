import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class PageCubit extends Cubit<int> {
  PageCubit(int state) : super(state);
  void change(state) => emit(state);
}

class CounterCubit extends Cubit<int> {
  CounterCubit(int state) : super(state);
  void start(state) async {
    while (state > 0) {
      await Future.delayed(Duration(seconds: 1), () {
        // print('[After Delay] $state');
        state--;
        emit(state);
      });
    }
  }
}
