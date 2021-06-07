import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/api.dart';
import 'package:flutter_library_app/authui/login-header.dart';
import 'package:flutter_library_app/authui/login-image.dart';
import 'package:flutter_library_app/bloc/connection.dart';
import 'package:flutter_library_app/bloc/textvalidation.dart';
import 'package:flutter_library_app/bloc/user.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginWidget();
  }
}

class _LoginWidget extends State<LoginWidget> {
  int backCount = 0;
  TextEditingController phoneController = TextEditingController();
  var _textValidationCubit =
      TextValidationCubit(TextValidationState(code: '', validate: false));
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TextValidationCubit>(
      create: (BuildContext context) {
        return _textValidationCubit;
      },
      child: Scaffold(
        body: SafeArea(child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                      return Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: BlocBuilder<ConnectionBloc, ConnectivityState>(
                              builder: (context, internet) {
                            print('[ConnectionBloc ${internet.name}]');
                            return BlocBuilder<TextValidationCubit,
                                TextValidationState>(builder: (context, ui) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: LoginHeader()),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                      child: LoginImage(
                                          'images/undraw_Login_re_4vu2_transparent.png')),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: TextField(
                                              readOnly: true,
                                              onTap: () {
                                                print('[Here]');
                                                // TODO: implement complex dialog here
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Select a country',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      );
                                                    });
                                              },
                                              controller: TextEditingController(
                                                  text: '+91'),
                                              decoration: InputDecoration(
                                                  suffixIcon: Icon(
                                                      Icons.arrow_drop_down),
                                                  counterText: '',
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Code'),
                                            ),
                                            flex: 1),
                                        Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 0),
                                                child:
                                                    // LoginPhoneField(phoneController),
                                                    TextField(
                                                  onChanged: (updatedNumber) {
                                                    BlocProvider.of<
                                                                TextValidationCubit>(
                                                            context)
                                                        .change(TextValidationState(
                                                            validate:
                                                                ui.validate,
                                                            code: updatedNumber
                                                                .toString()));
                                                  },
                                                  controller: phoneController,
                                                  maxLength: 10,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      errorText: ui.isError
                                                          ? ui.message
                                                          : null,
                                                      counterText: '',
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText:
                                                          'Phone Numbers'),
                                                )),
                                            flex: 3),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  ElevatedButton(
                                      onPressed: (ui.code == null ||
                                              ui.code.isEmpty ||
                                              ui.code.length < 10)
                                          ? null
                                          : () async {
                                              print('[Root][Welcome]');
                                              bool internetNotAvailable = true;
                                              if (internet.name != 'none') {
                                                internetNotAvailable = false;
                                              }
                                              if (!internetNotAvailable) {
                                                BlocProvider.of<
                                                            TextValidationCubit>(
                                                        context)
                                                    .change(TextValidationState(
                                                        isError: false,
                                                        message: '',
                                                        code: ui.code,
                                                        validate:
                                                            internetNotAvailable));
                                                BuildContext
                                                    loadingDialogContext;
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      loadingDialogContext =
                                                          context;
                                                      return getAlertDialog(
                                                          'Verifying');
                                                    });
                                                await Future.delayed(Duration(
                                                    milliseconds: 150));
                                                context.read<UserBloc>().add(
                                                    Loading(
                                                        phone: phoneController
                                                            .text));

                                                UserAuthAPIResponse
                                                    useridResponse =
                                                    await sendOTPService(
                                                        phone: phoneController
                                                            .text);
                                                Navigator.pop(
                                                    loadingDialogContext);
                                                if (useridResponse.success) {
                                                  // context.read<UserBloc>().add(
                                                  //     Auth(useridResponse));
                                                  context.read<UserBloc>().add(
                                                      SetAuthTokenEvent(
                                                          useridResponse
                                                              .userid));

                                                  print('[Root][Load] After');
                                                  Navigator.pushNamed(
                                                      context, '/otp');
                                                } else {
                                                  BlocProvider.of<
                                                              TextValidationCubit>(
                                                          context)
                                                      .change(TextValidationState(
                                                          isError:
                                                              useridResponse
                                                                  .isError,
                                                          message:
                                                              useridResponse
                                                                  .message,
                                                          code: ui.code,
                                                          validate:
                                                              internetNotAvailable));
                                                }
                                              } else {
                                                BlocProvider.of<
                                                            TextValidationCubit>(
                                                        context)
                                                    .change(TextValidationState(
                                                        isError:
                                                            internetNotAvailable,
                                                        message:
                                                            'Internet is not available.',
                                                        code: ui.code,
                                                        validate:
                                                            internetNotAvailable));
                                              }
                                            },
                                      child: Text('GET OPT')),
                                  // ${ui.validate} ||${internet.name} ||${ui.code}
                                  // Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20))
                                ],
                              );
                            });
                          }));
                    }),
                  )));
        })),
      ),
    );
  }
}

getAlertDialog(title) {
  return AlertDialog(
    elevation: 1,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(),
    ),
    content: Container(
      height: 80,
      // color: Colors.black12,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
