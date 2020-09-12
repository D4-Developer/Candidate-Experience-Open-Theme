import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../forms/Data.dart';

var userData;
class ResumeRank extends StatefulWidget {
  List skillTypes = [];
  List<bool> skillBox = [];
  final List skillsNeeded = [];
  ResumeRank(var  u){
    userData = u;
  }
  @override
  _ResumeRankState createState() => _ResumeRankState();
}

class _ResumeRankState extends State<ResumeRank> {
  List values = [10,9,8,7,6,5];
  final streamQuery = Firestore.instance.collection('candidates');
//      .where('Details.job', isEqualTo: '${userData['Details']['job']}');
//        .where('TechnicalSkills.skills', isEqualTo: userData['TechnicalSkills']);
  void getSkillsTypes(String match) {
    widget.skillTypes.clear();
    widget.skillTypes = List.from(widget.skillTypes)..addAll(skillsByRole.map((map) => SkillModel.fromJson(map))
        .where((object) => object.job == match)
        .map((object) => object.skills)
        .expand((i) => i)
        .toList());
//    print(widget.skillTypes.length);
  }

  void getRanking(List <DocumentSnapshot> documents) async{

    for(int i =0 ; i< documents.length; i++){
      getSkillsTypes(documents.elementAt(0).data['Details']['job']);
      var userS = documents.elementAt(i).data['TechnicalSkills'].length;
      var totalS = widget.skillTypes.length;
      var skillsR = userS/totalS * 10;

      var userA = documents.elementAt(i).data['isGivenTest'] ? documents.elementAt(i).data['TestResult'] / 2.5 : 0;
      var userP = documents.elementAt(i).data['isGivenPersonality'] == 1 ? documents.elementAt(i).data['PersonalityR'] / 15 : 0;
      var userPro = documents.elementAt(i).data['Projects'].length;
      if(userPro == 1)
        userPro = 7;
      else
        userPro = 10;
      var userEdu;
      if(documents.elementAt(i).data['Details']['education'] == 'Diploma Graduate')
        userEdu = 7;
      else if(documents.elementAt(i).data['Details']['education'] == 'Diploma Graduate')
        userEdu = 8;
      else
        userEdu = 10;
      var sum = values[0] +values[2] +values[3] +values[4] +values[5];
      var result;
        result = (skillsR * values[0] + userEdu * values[2] + userPro * values[3] + userA * values[4] + userP * values[5]) / sum * 10;
      print('result = $result');
      var UID = documents.elementAt(i).data['UID'];
      var data = {
        'ResumeRanking': result,

      };
      await Firestore.instance.collection('candidates').document(UID).updateData(data);
    }

    //      print(' skills of candidate ${documents.elementAt(i).data['DisplayName']}');
//    print(' length = ${widget.skillTypes.length}');
  }

  @override
  Widget build(BuildContext context) {
    List<int> rankings = [1,2,3,4,5,6,7,8,9,10];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          automaticallyImplyLeading: false,
          title: Text("All Candidates Ranking"),
          actions: <Widget>[
            RaisedButton(
              color: Colors.blue[900],
              child: Icon(Icons.filter_list, color: Colors.blue[50],),
              onPressed: () {
                showModalBottomSheet(context: context, builder: (BuildContext context) {
                  return Container(
                    width: 300,
                    height: 500,
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text('Skills Weightage'),
                          subtitle: DropdownButton <int> (
                        value: values[0],
                            items: rankings.map((int item) {
                              return DropdownMenuItem<int>(
                                  child: Text('$item', textScaleFactor: 1,), value: item);
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return rankings.map<Widget>((int item) {
                                return Container(
//                    color: Colors.blue,
//                                padding: EdgeInsets.only(left: width/25),
                                    child: Text('$item', textScaleFactor: 1,)
                                );
                              }).toList();
                            },
                            onChanged: (int a){
                              setState(() {
                                values[0] = a;
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                        ListTile(
                          title: Text('Experience Weightage'),
                          subtitle: DropdownButton <int> (
                        value: values[1],
                            items: rankings.map((int item) {
                              return DropdownMenuItem<int>(
                                  child: Text('$item', textScaleFactor: 1,), value: item);
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return rankings.map<Widget>((int item) {
                                return Container(
//                    color: Colors.blue,
//                                padding: EdgeInsets.only(left: width/25),
                                    child: Text('$item', textScaleFactor: 1,)
                                );
                              }).toList();
                            },
                            onChanged: (int a){
                              setState(() {
                                values[1] = a;
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                        ListTile(
                          title: Text('Education Weightage'),
                          subtitle: DropdownButton <int> (
                        value: values[2],
                            items: rankings.map((int item) {
                              return DropdownMenuItem<int>(
                                  child: Text('$item', textScaleFactor: 1,), value: item);
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return rankings.map<Widget>((int item) {
                                return Container(
//                    color: Colors.blue,
//                                padding: EdgeInsets.only(left: width/25),
                                    child: Text('$item', textScaleFactor: 1,)
                                );
                              }).toList();
                            },
                            onChanged: (int a){
                              setState(() {
                                values[2] = a;
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                        ListTile(
                          title: Text('Projects Weightage'),
                          subtitle: DropdownButton <int> (
                        value: values[3],
                            items: rankings.map((int item) {
                              return DropdownMenuItem<int>(
                                  child: Text('$item', textScaleFactor: 1,), value: item);
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return rankings.map<Widget>((int item) {
                                return Container(
//                    color: Colors.blue,
//                                padding: EdgeInsets.only(left: width/25),
                                    child: Text('$item', textScaleFactor: 1,)
                                );
                              }).toList();
                            },
                            onChanged: (int a){
                              setState(() {
                                values[3] = a;
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                        ListTile(
                          title: Text('AptitudeTest Weightage'),
                          subtitle: DropdownButton <int> (
                        value: values[4],
                            items: rankings.map((int item) {
                              return DropdownMenuItem<int>(
                                  child: Text('$item', textScaleFactor: 1,), value: item);
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return rankings.map<Widget>((int item) {
                                return Container(
//                    color: Colors.blue,
//                                padding: EdgeInsets.only(left: width/25),
                                    child: Text('$item', textScaleFactor: 1,)
                                );
                              }).toList();
                            },
                            onChanged: (int a){
                              setState(() {
                                values[4] = a;
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                        ListTile(
                          title: Text('PersonalityTest Weightage'),
                          subtitle: DropdownButton <int> (
                        value: values[5],
                            items: rankings.map((int item) {
                              return DropdownMenuItem<int>(
                                  child: Text('$item', textScaleFactor: 1,), value: item);
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return rankings.map<Widget>((int item) {
                                return Container(
//                    color: Colors.blue,
//                                padding: EdgeInsets.only(left: width/25),
                                    child: Text('$item', textScaleFactor: 1,)
                                );
                              }).toList();
                            },
                            onChanged: (int a){
                          setState(() {
                            values[5] = a;
                          });
                           },
                            isExpanded: true,
                          ),
                        ),
                        RaisedButton(
                          child: Text('SAVE'),
                          onPressed: () =>
                            Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                });
              },
            )
          ],
        ),
        body: SafeArea(
          child: getStreams()
        )
    );

  }

  Widget getStreams() {
    return FutureBuilder<QuerySnapshot>(
        future: streamQuery.getDocuments(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasError) return Text('${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              {
                print(snapshot.data.documents.length);
                List <DocumentSnapshot> documents = snapshot.data.documents;
                if(snapshot.data.documents.length > 0) {
                  getRanking(documents);
                  return StreamBuilder<QuerySnapshot>(
                      stream: streamQuery.orderBy('ResumeRanking', descending: true)
                      /// getting error in orderBy('', );
//            .orderBy('TestResult', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                        print(snapshot.hasData);

                        if (snapshot.hasError) return Text('${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            {
                              print(snapshot.data.documents.length);
                              List <DocumentSnapshot> documents = snapshot.data.documents;
                              if(snapshot.data.documents.length > 0) {
                                getRanking(documents);
                                return ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: documents.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return Card(
                                      color: Colors.blue[50],
                                      child: ListTile(
                                        leading: Icon(Icons.people),
                                        title: Text("${documents.elementAt(index)['DisplayName']}"),
                                        subtitle: Text("Ranking : ${documents.elementAt(index)['ResumeRanking'].toStringAsPrecision(4)}"),
                                      ),
                                    );
                                  },
                                );
                              }
                              return Center(
                                child: Text("No Candidate Based On Your Requirements", textScaleFactor: 1,),
                              );
                            }
                        }
                      });
                }
                return Center(
                  child: Text("No Candidate Based On Your Requirements", textScaleFactor: 1,),
                );
              }
          }
        });

  }
}



