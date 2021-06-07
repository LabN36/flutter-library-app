import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select your language',
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          TextButton(
                              onPressed: () {
                                print('[English]');
                                context.setLocale(Locale('en', ''));
                                //change locale here
                              },
                              child: Chip(
                                elevation: 3,
                                backgroundColor: Colors.white10,
                                avatar: CircleAvatar(
                                  backgroundColor: Colors.blue.shade800,
                                  child: Text('E'),
                                ),
                                label: Text('English'),
                              )),
                          Chip(
                            elevation: 3,
                            backgroundColor: Colors.white10,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.blue.shade800,
                              child: Text('H'),
                            ),
                            label: Text('Hindi'),
                          )
                        ],
                      ),
                    ));
              });
        },
        child: Row(
          children: [Text('Language'), Icon(Icons.arrow_drop_down)],
        ));
  }
}
