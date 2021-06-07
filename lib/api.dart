import 'dart:convert';
import 'dart:io';

import 'package:flutter_library_app/bloc/user.dart';
import 'package:http/http.dart' as http;

String url = 'https://flutter.tutehub.dev';

sendOTPService({phone, userid}) async {
  print('[sendOTPService]  ${DateTime.now()}');
  print('phone number $phone');
  var client = http.Client();
  try {
    var uriResponse = await client.post(Uri.parse('$url/sendtext'),
        body: jsonEncode({'phone': phone}),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    var useridResponse =
        UserAuthAPIResponse.fromJson(jsonDecode(uriResponse.body));
    print(jsonDecode(uriResponse.body));
    print('[Response Body][sendOTPService]  ${DateTime.now()}');
    return useridResponse;
  } catch (e) {
    print(e);
  } finally {
    client.close();
  }
}

verifyOTP(String userid, String otp) async {
  print('[Function][verifyOTP]  ${DateTime.now()}');
  var client = http.Client();
  try {
    print("{'userid':$userid,'otp':$otp }");
    var uriResponse = await client.post(Uri.parse('$url/verify'),
        body: jsonEncode({'userid': userid, 'otp': otp}),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(uriResponse.body);

    var user = UserAuthAPIResponse.fromJson(jsonDecode(uriResponse.body));
    print('[Response Body][verifyOTP]  ${DateTime.now()}');
    return user;
  } finally {
    client.close();
  }
}
