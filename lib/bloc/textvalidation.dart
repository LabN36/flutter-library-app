import 'package:flutter_bloc/flutter_bloc.dart';

class TextValidationState {
  String code;
  bool validate;
  bool isError = false;
  String message;
  bool manualFlow = true;
  TextValidationState({code, validate, isError, message, manualFlow}) {
    this.code = code;
    this.validate = validate;
    this.isError = isError ?? false;
    this.message = message;
    this.manualFlow = manualFlow ?? true;
  }
}

class TextValidationCubit extends Cubit<TextValidationState> {
  TextValidationCubit(TextValidationState state) : super(state);

  void change(state) {
    emit(state);
  }
}
