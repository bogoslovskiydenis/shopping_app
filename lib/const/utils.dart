import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBarWithViewBag(BuildContext context, String s) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('$s'),
    action: SnackBarAction(
      label: 'View Bag',
      onPressed: () => Navigator.of(context).pushNamed('/cartDetail'),
    ),
  ));
}

void showOnlySnackBar(BuildContext context, String s) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('$s'),

  ));
}
