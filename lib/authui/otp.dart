import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_library_app/api.dart';
import 'package:flutter_library_app/authui/login-header.dart';
import 'package:flutter_library_app/authui/login-image.dart';
import 'package:flutter_library_app/bloc/counter.dart';
import 'package:flutter_library_app/bloc/textvalidation.dart';
import 'package:flutter_library_app/bloc/user.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OTPWidget();
  }
}

class _OTPWidget extends State<OTPWidget> with CodeAutoFill {
  String _code = '';
  var counterBloc = CounterCubit(0);
  var textValidationCubit =
      TextValidationCubit(TextValidationState(code: '', validate: false));
  var otpController = TextEditingController(text: '');
  bool _validate = false;
  BuildContext loadingDialogContext;
  @override
  void codeUpdated() {
    print('[codeUpdated] $code');
    textValidationCubit
        .change(TextValidationState(code: code, manualFlow: false));
    otpController.value = TextEditingValue(text: code);
  }

  @override
  void initState() {
    super.initState();
    this.counterBloc.start(30);
    listenForCode();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<CounterCubit>(create: (BuildContext context) {
            return counterBloc;
          }),
          BlocProvider<TextValidationCubit>(create: (BuildContext context) {
            return textValidationCubit;
          }),
        ],
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(builder:
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
                          child: BlocConsumer<TextValidationCubit,
                              TextValidationState>(
                            listenWhen: (previous, current) {
                              print(
                                  '[listenWhen] ${previous.code}  ${current.code}');
                              if (previous.code == current.code &&
                                  !current.manualFlow) {
                                //  &&current.code.length < 5 -> not stable condition
                                return false;
                              } else {
                                return true;
                              }
                            },
                            listener: (context, ui) async {
                              print('[BlocListener] ${ui.code}');
                              if (ui.code != null && ui.code.length == 6) {
                                print('[BlocListener] 6 digit passed');
                                if (ui.manualFlow) {
                                  //show dialog
                                  // showDialog(
                                  //     useSafeArea: true,
                                  //     barrierDismissible: false,
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       loadingDialogContext = context;
                                  //       return getAlertDialog('Manual Flow');
                                  //     });
                                } else {
                                  //just verify

                                  if (state.phone != null &&
                                      state.userid != null) {
                                    print(
                                        '[BlocListener] ${state.phone} ${state.userid}');
                                    UserAuthAPIResponse user =
                                        await verifyOTP(state.userid, ui.code);
                                    if (user.success) {
                                      context.read<UserBloc>().add(Auth(user));
                                      Navigator.popUntil(
                                          context,
                                          ModalRoute.withName(
                                              Navigator.defaultRouteName));
                                    } else {
                                      context.read<UserBloc>().add(WrongOTP());
                                      BlocProvider.of<TextValidationCubit>(
                                              context)
                                          .change(TextValidationState(
                                              code: ui.code,
                                              isError: user.isError,
                                              manualFlow: ui.manualFlow,
                                              validate: ui.validate,
                                              message: user.message));
                                    }
                                  } else {
                                    print(
                                        '[BlocListener] either phone or user is is null');
                                  }
                                }
                                //Verification Part
                                if (loadingDialogContext != null) {
                                  //TODO: fix this
                                  Navigator.pop(loadingDialogContext);
                                }
                                print('[After verifyOTP]');
                              }
                            },
                            builder: (context, ui) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: LoginHeader()),
                                  Text(
                                    'Please Provide your 6-digit OTP for verification',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text.rich(TextSpan(
                                            style: TextStyle(
                                              fontSize: 17,
                                              // textBaseline: TextBaseline.alphabetic
                                            ),
                                            children: [
                                              TextSpan(
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationStyle:
                                                        TextDecorationStyle
                                                            .solid,
                                                    decorationThickness: 4,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue),
                                                text: state.phone,
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 17,
                                                ),
                                              )
                                            ])),
                                      ],
                                    ),
                                    onTap: () async {
                                      print('[Edit Phone Number]');
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                      child: LoginImage(
                                          'images/undraw_Cloud_sync_re_02p1_transparent.png')),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: TextField(
                                      onSubmitted: (str) {
                                        print('[onSubmitted] $str');
                                      },
                                      onTap: () {
                                        print('ON Tap');
                                      },
                                      onChanged: (str) {
                                        print('[onChanged] $str');
                                        if (ui.manualFlow)
                                          BlocProvider.of<TextValidationCubit>(
                                                  context)
                                              .change(TextValidationState(
                                                  code: otpController.text));
                                      },
                                      controller: otpController,
                                      maxLength: 6,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          counterText: '',
                                          errorText: ui.isError == true
                                              ? ui.message
                                              : null,
                                          border: OutlineInputBorder(),
                                          labelText: 'Please Enter OTP'),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  ElevatedButton(
                                      onPressed: (ui.code == null ||
                                              ui.code.isEmpty ||
                                              ui.code.length < 6)
                                          ? null
                                          : () async {
                                              print('[Manual Flow]: Button');
                                              showDialog(
                                                  useSafeArea: true,
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    loadingDialogContext =
                                                        context;
                                                    return getAlertDialog(
                                                        'Manual Flow');
                                                  });
                                              await Future.delayed(
                                                  Duration(milliseconds: 150));
                                              BlocProvider.of<
                                                          TextValidationCubit>(
                                                      context)
                                                  .change(TextValidationState(
                                                      code: ui.code,
                                                      validate: true,
                                                      manualFlow: true));

                                              if (state.phone != null &&
                                                  state.userid != null) {
                                                print(
                                                    '[BlocListener] ${state.phone} ${state.userid}');
                                                UserAuthAPIResponse user =
                                                    await verifyOTP(
                                                        state.userid, ui.code);
                                                if (user.success) {
                                                  print('[OTP Success]');
                                                  context
                                                      .read<UserBloc>()
                                                      .add(Auth(user));
                                                  Navigator.popUntil(
                                                      context,
                                                      ModalRoute.withName(
                                                          Navigator
                                                              .defaultRouteName));
                                                } else {
                                                  context
                                                      .read<UserBloc>()
                                                      .add(WrongOTP());
                                                  BlocProvider.of<
                                                              TextValidationCubit>(
                                                          context)
                                                      .change(
                                                          TextValidationState(
                                                              code: ui.code,
                                                              isError:
                                                                  user.isError,
                                                              manualFlow:
                                                                  ui.manualFlow,
                                                              validate:
                                                                  ui.validate,
                                                              message: user
                                                                  .message));
                                                }
                                              }

                                              //TODO: call verify otp API manually
                                            },
                                      child: Text('VERIFY OTP')),
                                  BlocBuilder<CounterCubit, int>(
                                      builder: (contexts, counter) {
                                    if (counter > 0) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Resend OTP',
                                                style: TextStyle(
                                                    color: Colors.grey)),
                                            Text(
                                              '(00:$counter)',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            child: Text('Resend OTP'),
                                            onPressed: () async {
                                              print('[Resending OTP Flow] v2');
                                              await SmsAutoFill().listenForCode;

                                              showDialog(
                                                  useSafeArea: true,
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    loadingDialogContext =
                                                        context;
                                                    return getAlertDialog(
                                                        'Verifying');
                                                  });
                                              //Sending Part
                                              context.read<UserBloc>().add(
                                                  Loading(phone: state.phone));
                                              try {
                                                UserAuthAPIResponse
                                                    useridResponse =
                                                    await sendOTPService(
                                                        phone: state.phone,
                                                        userid: state.userid);
                                                if (useridResponse.success) {
                                                  context.read<UserBloc>().add(
                                                      SetAuthTokenEvent(
                                                          useridResponse
                                                              .userid));
                                                  Navigator.pop(
                                                      loadingDialogContext);
                                                } else {
                                                  Navigator.pop(
                                                      loadingDialogContext);
                                                  BlocProvider.of<
                                                              TextValidationCubit>(
                                                          context)
                                                      .change(
                                                          TextValidationState(
                                                    isError:
                                                        useridResponse.isError,
                                                    message:
                                                        useridResponse.message,
                                                    code: ui.code,
                                                  ));
                                                }
                                              } catch (e) {
                                                // await Future.delayed(Duration(
                                                //     milliseconds: 200));
                                                // Navigator.pop(
                                                //     loadingDialogContext);
                                                print('[Error Re-Sending OTP]');
                                                BlocProvider.of<
                                                            TextValidationCubit>(
                                                        context)
                                                    .change(TextValidationState(
                                                        code: ui.code,
                                                        validate: ui.validate,
                                                        isError: true,
                                                        message:
                                                            'Please try again'));
                                              }
                                            },
                                          )
                                        ],
                                      );
                                    }
                                  })
                                ],
                              );
                            },
                          ),
                        );
                      }),
                    )),
              );
            }),
          ),
        ));
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
