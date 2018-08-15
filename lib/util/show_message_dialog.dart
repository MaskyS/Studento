import 'package:flutter/material.dart';

void showMessageDialog(BuildContext context, {@required String msg, String closeButtonText = "OK"}) => showDialog(
  context: context,
  builder: (_) => AlertDialog(
    content: Text(msg),
    actions: <Widget>[
      FlatButton(child: Text(closeButtonText),
      onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  ),
);