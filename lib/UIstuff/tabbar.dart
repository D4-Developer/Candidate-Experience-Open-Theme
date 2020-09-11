import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override
  _myApp createState() => _myApp();
}
class _myApp extends State<MyApp> {
var tab=0;
  @override
  Widget build(BuildContext){

    if(tab==0) {
      return (
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text("TabBar"),
              ),
              body: ListView(
                children: <Widget>[
                  Container(
                      child: Center(
                        child: Text("taBar"),
                      )
                  ),
                  DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: TabBar(
                      tabs: <Widget>[
                        Tab(text: "Contact Details",
                          icon: Icon(Icons.four_k, color: Colors.cyanAccent,),),
                        Tab(text: "Hiring for",)
                      ],
                      onTap: (val) {
                        print("Tapped $val");
                        if (val != tab) {
                          setState(() {
                            tab=val;
                          });
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 340,
                    height: 340,
                    child: Center(child: Text("value with 0")),
                    color: Colors.blueGrey,
                  )
                ],
              ),
            ),
          )
      );
    }
    else{
      return (
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text("TabBar"),
              ),
              body: ListView(
                children: <Widget>[
                  Container(
                      child: Center(
                        child: Text("taBar"),
                      )
                  ),
                  DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: TabBar(
                      tabs: <Widget>[
                        Tab(text: "Contact Details",
                          icon: Icon(Icons.four_k, color: Colors.cyanAccent,),),
                        Tab(text: "Hiring for",)
                      ],
                      onTap: (val) {
                        print("Tapped $val");
                        if (val != tab) {
                          setState(() {
                            tab=val;
                          });
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 340,
                    height: 540,
                    child: Center(child: Text("value with 1")),
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          )
      );
    }
  }
}

class show0 extends StatefulWidget{
  @override
  _show0 createState() => _show0();
}

class _show0 extends State<show0>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Text("value with 0"),
      color: Colors.blueGrey,
    );
  }
}
class show1 extends StatefulWidget{
  @override
  _show1 createState() => _show1();
}

class _show1 extends State<show1>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Text("value with 1"),
      color: Colors.grey,
    );
  }
}