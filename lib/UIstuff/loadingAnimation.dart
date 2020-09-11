import 'package:flutter/material.dart';

void loadingAnimation(BuildContext context, String label) {
  showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) =>
      Container(
        color: Color.fromARGB(50, 0, 151, 255),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding( padding: EdgeInsets.all(5) ),
              Text(" $label ", style: TextStyle(fontSize: 20, color: Colors.blue[900],decoration: TextDecoration.none), )
            ],
          ),
        ),
      )
  );
}
