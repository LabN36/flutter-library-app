import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_library_app/authui/language-widget.dart';

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          Text(
            'login'.tr(),
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
      LanguageWidget()
    ]);
  }
}
