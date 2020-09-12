import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../UIstuff/loadingAnimation.dart';

final List<String> personalityQuestions = [
  'You have an active imagination',
  'Get  excited by new ideas',
  'Avoid philosophical discussions',
  'Belive in the importance of art',
  'Carry the conversation to a higer level',
  'Always listen to the others ideas',
  'You does your work efficiently',
  'You tends to be lazy',
  'Pay attention to details',
  'Need a push to get started',
  'Finish what i started',
  'Shirk my duties',
  'Make friend easily',
  'You are sociable',
  'You are sort tempered',
  "Don't talk a lot ",
  "Dont't like to draw attention to myself",
  'I am skilled in handling social situations',
  'You are sometime rude to others',
  'You are soft harted',
  'Easy to satisfy',
  'Make demands on others',
  'Sympathize with others feeling',
  'Accept people the way they are',
  'Worries a lot',
  'Get nervous easily',
  'Handles stress well',
  'Do you blush more often than most people',
  'Have frequent mood swings',
  'Do you have sometime feel that you can not overcome from your problems',
];

final List<String> option =
['strongly agree','agree','neither agree nor disagree','disagree','strongly disagree'];

final List<List<int>> answers = [
  [5,4,3,2,1],[5,4,3,2,1],[1,4,5,3,2],[5,4,3,2,1],[5,4,3,2,1],[5,4,3,2,1],
  [5,4,3,2,1],[1,2,3,4,5],[5,4,3,2,1],[1,2,3,4,5],[5,4,3,2,1],[1,2,3,4,5],
  [5,4,3,2,1],[5,4,3,2,1],[1,2,3,4,5],[1,4,5,3,2],[1,4,5,3,2],[5,4,3,2,1],
  [1,2,3,4,5],[5,4,3,2,1],[5,4,3,2,1],[1,2,3,4,5],[5,4,3,2,1],[5,4,3,2,1],
  [1,2,3,4,5],[1,2,3,4,5],[5,4,3,2,1],[1,2,3,4,5],[1,2,3,4,5],[1,2,3,4,5],
];

class PersonalityTest extends StatefulWidget {
  var userData;
//  final isStarted;
  PersonalityTest(this.userData);

  _list createState() => _list(userData);
}

class _list extends State<PersonalityTest> {
  var userData;
  _list(userData);

  bool isLoaded = false;
  int total, users;
  var width, height;

//    List<charts.Series<BarChartData, String>> series;
  List<int> grVal = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];


  @override
  Widget build(BuildContext context) {
    print(widget.userData['isGivenPersonality']);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if(widget.userData['isGivenPersonality'] == -1){
        return Center(
          child: Column(
            children: <Widget>[
              Center(
                child: RaisedButton(
                  child: Text("Start Personality Test. "),
                  onPressed: () {
                    widget.userData['isGivenPersonality'] = 0;
//                    print("started");
                    setState(() {

                    });
                  },
                ),
              ),
              Text("You have only 1 chance for this test")
            ],
          ),
        );
    }
    else if(widget.userData['isGivenPersonality'] == 0){
      return WillPopScope(
        onWillPop: () async{
          showDialog(context: context,
              child: AlertDialog(
                title: Text("Are you sure to quit from the personality test?"),
                actions: <Widget>[
                  RaisedButton(
                    shape: StadiumBorder(),
                    child: Text(" No "),
                    color: Colors.red[800],
                    onPressed: () => Navigator.pop(context),
                  ),
                  RaisedButton(
                    shape: StadiumBorder(),
                    child: Text(" Yes "),
                    color: Colors.blue[800],
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("PERSONALITY TEST PAGE"),
          ),
          body: SafeArea(
            child: Container(
                child: ListView(
                    children: <Widget>[

                      Container(
                        color: Colors.blue[200],
                        height: height - height / 3.7,
                        child: ListView.builder(
                          controller: ScrollController(),
                        physics: ClampingScrollPhysics(),

                          itemCount: 30,
                          itemBuilder: (context, index0) {
                            return Card(
                                child: Column(
                                    children: <Widget>[
                                      Text("${index0 + 1} "),
                                      ListTile(
                                        title: Text(personalityQuestions[index0]),
                                        subtitle:
                                        ListView.builder(
                                          itemBuilder: (context, index1) {
                                            return RadioListTile(
                                                groupValue: grVal[index0],
                                                value: index1 + 1,
                                                selected: true,
                                                onChanged: (value) {
                                                  setState(() {
//                                                  print(grVal);
                                                    grVal[index0] = value;
                                                    print(grVal);
                                                  });
                                                },
                                                activeColor: Colors.greenAccent,
                                                title: Text(
                                                    option[index1])
                                            );
                                          },
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          physics: ClampingScrollPhysics(),
                                        ),
                                      ),
                                    ]
                                )
                            );
                          },
                        ),
                      ),
//
                      RaisedButton(
                          shape: StadiumBorder(),
                          color: Colors.blue[900],
                          textColor: Colors.blue[100],
                          child: Text("SUBMIT  ANSWERS"),
                          onPressed: () {
                            alertUser();
                          }
                      )
                    ]
                )
            ),
          ),
        ),
      );
    }
    else{
      var openness = widget.userData['PersonalityResult']['openness'] * 100 / 30,
          conscientiouness = widget.userData['PersonalityResult']['conscientiousness']  * 100 / 30,
          extraversion = widget.userData['PersonalityResult']['extraversion']  * 100 / 30,
          agreeableness = widget.userData['PersonalityResult']['agreeableness'] * 100 / 30,
          neuroticism = widget.userData['PersonalityResult']['neuroticism'] * 100 / 30;
      return Scaffold(
          appBar: AppBar(
          title: Text('Personality Test'),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue[900],
          ),
          body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Text("Result"),
              ),
              Flexible(
                child: Container(
//                height: 300,
                  child:ListWheelScrollView(
                    itemExtent: 50,
                    children: <Widget>[
                      ListTile(
                        title: Text('openness'),
                        subtitle: Text('$openness%'),
                      ),
                      ListTile(
                        title: Text('conscientiouness'),
                        subtitle: Text('$conscientiouness%'),
                      ),
                      ListTile(
                        title: Text('extraversion%'),
                        subtitle: Text('$extraversion'),
                      ),
                      ListTile(
                        title: Text('agreeableness%'),
                        subtitle: Text('$agreeableness'),
                      ),
                      ListTile(
                        title: Text('neuroticism%'),
                        subtitle: Text('$neuroticism'),
                      )
                    ],
                  )
                ),
              )
            ],
          )
      );
    }
  }

  void alertUser() {
    showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: true,
        builder: (context) =>
            AlertDialog(
              title: Text("      Alert"),
              content: Container(
                  color: Colors.blueGrey[100],
                  width: 200,
                  height: 150,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                          "Once You Submit You Can\nnot be able to attend second time"),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.done_all, color: Colors.green),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).pop();
                                progressIndicator(true);
                              },
                            ),
                          ]
                      )
                    ],
                  )
              ),
            )
    );
  } // alertUser
  Future<void> progressIndicator(bool isRedirect) async {
    int resultO = 0,resultC = 0,resultE = 0,resultA = 0,resultN = 0;
    loadingAnimation(context, 'Getting Result...');

    for (int i = 0; i < 6; i++)
      if(grVal[i]!=0)
        resultO += answers[i][grVal[i]-1];
    for (int i = 6; i < 12; i++)
      if(grVal[i]!=0)
        resultC += answers[i][grVal[i]-1];
    for (int i = 12; i < 18; i++)
      if(grVal[i]!=0)
        resultE += answers[i][grVal[i]-1];
    for (int i = 18; i < 24; i++)
      if(grVal[i]!=0)
        resultA += answers[i][grVal[i]-1];
    for (int i = 24; i < 30; i++)
      if(grVal[i]!=0)
        resultN += answers[i][grVal[i]-1];

//    print(resultO);
//    print(resultC);
//    print(resultE);
//    print(resultA);
//    print(resultN);

    var testResult = {
      'openness': resultO,
      'conscientiousness': resultC,
      'extraversion': resultE,
      'agreeableness': resultA,
      'neuroticism': resultN,
    };
    var data = {
      'PersonalityResult': testResult,
      'isGivenPersonality': 1,
      'PersonalityR': (resultA+resultC+resultE+resultN+resultO)/5
    };

    await Firestore.instance.collection('candidates').document(widget.userData['UID']).updateData(data);
    widget.userData['PersonalityResult'] = testResult;
    widget.userData['isGivenPersonality'] = 1;
    setState(() {

    });
//    Navigator.pop(context);
//    Navigator.push
//    print("Wrong Answer Count = $result");

//    DocumentReference dr = Firestore.instance.collection('appData').document('TestResult');
//    var data = {
//      'isGivenTest': true,
//      'TestResult': result,
//    };
    Navigator.pop(context);
  }

}