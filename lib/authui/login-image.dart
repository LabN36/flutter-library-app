import 'package:flutter/material.dart';

class LoginImage extends StatelessWidget {
  String url;
  LoginImage(url) {
    this.url = url;
  }
  @override
  Widget build(BuildContext context) {
    return Image(
        // width: 400,
        // height: 400,
        image: AssetImage(url));
  }
}
