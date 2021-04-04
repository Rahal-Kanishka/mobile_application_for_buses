import 'dart:ui';

import 'package:flutter/material.dart';

class BasicAlert extends StatelessWidget {
  String _title;
  String _content;
  String _yes;
  String _no;
  Function _yesOnPressed;
  Function _noOnPressed;
  bool isError;

  BasicAlert(this._title, this._content, this._yes, this._no,
      this._yesOnPressed, this._noOnPressed, [this.isError = false]);

  TextStyle textStyle = TextStyle(color: Colors.black);
  TextStyle contentStyle = TextStyle(color: Colors.black);
  TextStyle errorStyle = TextStyle(color: Colors.redAccent);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        title: Text(this._title, style: textStyle),
        content: Text(this._content, style: this.isError ? errorStyle: contentStyle),
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
        actions: [
          FlatButton(
            child: Text(this._yes),
            onPressed: (){
              this._yesOnPressed();
            },
          ),FlatButton(
            child: Text(this._no),
            onPressed: (){
              this._noOnPressed();
            },
          ),
        ],
      ),
    );
  }
}
