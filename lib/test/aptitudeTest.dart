import 'dart:async';
import '../test/pie_R.dart';
import 'package:flutter/material.dart';
import '../UIstuff/loadingAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

var userData;
FirebaseAuth _auth;

final List<String> question = [
  "X and Y can together do a piece of work in 15 days. Y alone can do it in 20 days. In how many days can X alone do it ?",
  "X can do (1/3) of a work in 5 days and Y can do (2/5) of the work in 10 days. In how many days both X and Y together can do the work ?",
  "M can do a piece of work in 30 days while N can do it in 40 days. In how many days can M and N working together do it ?",
  "X, Y and Z together earn Rs. 150 per day while X and Z together earn Rs. 94 and Y and Z together earn Rs. 76. The daily earning of Z is:",
  "The rates of working of M and N are in the ratio 3 : 4. The number of days taken by them to finish the work are in the ratio:",
  "If one-fourth of one-third of one-half of a number is 15, the number is:",
  "A positive number when decreased by 4, is equal to 21 times the reciprocal of the number. The number is:",
  "A number is as much greater than 31 as is less than 55. The number is:",
  "24  is divided into two parts such that 7 times the first part added in 5 time the second part makes 146. The first part is:",
  "The ratio between two numbers is 3:4 and their sum is 420. The greater of the two numbers is:",
  "If 300 men can do a piece of work in 16 days, how many men would do (1/5) of the work in 15 days ?",
  "If six men working 8 hours a day earn Rs. 840 per week, then 9 men working 6 hours a day will earn per week :",
  "20 men complete one-third of a piece of work in 20 days. How many more men should be employed to finish the rest of the work in 25 more days ?",
  "If 18 pumps can raise 2170 tonnes of water in 10 days, working 7 hours a day, in how many days will 16 pumps raise 1736 tonnes, working 9 hours a day ?",
  "If the rent for grazing 40 cows for 20 days is Rs. 370, how many cows can graze for 30 days on Rs. 111  ?",
  "A can contains a mixture of two liquids X and Y in the ratio 7 : 5. When 9 L mixture are drawn off and the can is filled with Y, the ratio of X and Y becomes 7 : 9. Litres of liquid X contained by the can initially was ",
  "3 containers has alcohol and water in ratio 2 : 1, 3 : 1, 3 : 2 respectively and all three containers are emptied into a bigger container, then ratio of alcohol in bigger container.",
  "A discount of 15% on one  is the same as a discount of 20% on another . The costs of the two articles can be:",
  "Offer is  2.5% discount on cash purchase. What cash amount would Ra j pay for a cycle, the marked price of which is Rs. 650?",
  "How many ways that can the letters of the word 'LEADER' be arranged?",
  "The least number which when divided by 5, 6 , 7 and 8 leaves a remainder 3, but when divided by 9 leaves no remainder, is:",
  "617 + 6.017 + 0.617 + 6.0017 = ____",
  "(256)0.16 x (256)0.09 = ?",
  "A train 240 m long passes a pole in 24 seconds. How long will it take to pass a platform 650 m long?",
  "X starts business with Rs. 3500 and after 5 months, Y joins with X as his partner. After a year, the profit is divided in the ratio 2 : 3. What is Y's contribution in the capital in Rs.?",
  "Let N be the greatest number that will divide 1305, 4665 and 6905, leaving the same remainder in each case. Then sum of the digits in N is:",
  "The difference between a two-digit number and the number obtained by interchanging the digits is 36. What is the difference between the sum and the difference of the digits of the number if the ratio between the digits of the number is 1 : 2 ?",
  "A,B and C contested an election and received 1136, 7636 and 11628 votes respectively. What percentage of the total votes did the winning candidate get?",
  "A flagstaff 17.5 m high casts a shadow of length 40.25 m. The height of the building, which casts a shadow of length 28.75 m under similar conditions will be:",
  "A paper was found to have lost 20% of its length and 10% of its breadth. The percentage of decrease in area is:",
  "The least multiple of 7, which leaves a remainder of 4, when divided by 6, 9, 15 and 18 is:",
  "If a quarter kg of potato costs 60 paise, how many paise will 200 gm cost?",
  "Sakshi can do a piece of work in 20 days. Tanya is 25% more efficient than Sakshi. The number of days taken by Tanya to do the same piece of work is:",
  "A train 125 m long passes a man, running at 5 km/hr in the same direction in which the train is going, in 10 seconds. The speed of the train is:",
  "Find out the wrong number in the given sequence of numbers.\n\t25, 36, 49, 81, 121, 169, 225"
];

final List<List<String>> option = [
  ["40 days","30 days","60 days","45 days"],
  ["10","835","939","734"],
  ["710 days","1717 days","27147 days","7117 days"],
  ["Rs. 71","Rs. 75","Rs. 39","Rs. 20"],
  ["4 : 3","9 : 16","3 : 4","none of these"],
  ["180","360","72","480"],
  ["7","6","3","9"],
  ["47","42","39","53"],
  ["21","17","16","13"],
  ["175","240","210","315"],
  ["66","61","64","72"],
  ["Rs. 840","Rs. 745","Rs. 945","Rs. 1680"],
  ["45","52","15","50"],
  ["8 days","9 days","7 days","6 days"],
  ["8","5","6","12"],
  ["10","21","20","25"],
  ["121 : 59","59 : 121","120 : 60","None of these"],
  ["Rs. 40, Rs. 20","Rs. 60, Rs. 40","Rs. 80, Rs. 60","Rs. 60, RS. 40"],
  ["Rs. 633.75","Rs. 633.25","Rs. 634","Rs. 635"],
  ["262","360","420","362"],
  ["1776","1677","3363","1863"],
  ["62.965","629.6357","6.2963","none of these"],
  ["16","64","4","256.25"],
  ["89 s","150 s","65 s","63 s"],
  ["7800","8000","8600","9000"],
  ["5","4","6","9"],
  ["8","16","4","2"],
  ["57%","52%","65%","89%"],
  ["10m","17.5m","12.5m","21.25m"],
  ["10%","10.8%","28%","20%"],
  ["74","184","364","94"],
  ["54 paise","57 paise","72 paise","48 paise"],
  ["16","18","15","24"],
  ["50 km/hr","45 km/hr","54 km/hr","56 km/hr"],
  ["49","121","169","36"]
];

final List<int> answers = [3,4,2,2,1, 2,1,4,4,2, 3,3,4,1,1, 2,1,3,1,2, 4,2,3,1,4, 2,1,1,3,3, 3,4,1,1,4];

class AptitudeTest extends StatefulWidget {
  AptitudeTest(FirebaseAuth auth, var u){ _auth = auth; userData = u; }
  _list createState() => _list();
}

class _list extends State<AptitudeTest> {

  bool isLoaded = false;
  int minute = 29, seconds = 60;
  int total,users;
  var width, height;
  List<charts.Series<BarChartData, String>> series;
  List<int> grVal=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  Duration timeout = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    startTimeout();
  }
  startTimeout() {
    return new Timer.periodic(timeout, (Timer T){
      setState(() {
        if(minute == 0 && seconds == 0){
          T.cancel();
          progressIndicator(false);
          showDialog(context: context, barrierDismissible: false,
              builder: (context) =>
              AlertDialog(
                title: Text('Time over'),
                actions: <Widget>[
                  RaisedButton(
                    color: Colors.blue[900],
                    child: Text('SHOW ME ANALYSIS'),
                    onPressed: () {
//                      print(isLoaded);
                      if(isLoaded){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>
                          pieCharts(series, userData['TestResult'].toDouble(), true)));
                        }
                      else
                        progressIndicator(true);
                    }
                  )
                ],
              )
          );
        }
        else if(seconds != 0)
          --seconds;
        else {
          seconds = 60;
          --minute;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Timer Ended')));
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("APTITUTE TEST PAGE"),
          
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue[900],
          actions: <Widget>[
            FlatButton(
              onPressed: null,
              child: Text('$minute : $seconds',style: TextStyle(color: Colors.blue[100]), textScaleFactor: 1,),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
              child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
//                controller: ScrollController(),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: height/68),
                      height: height - height/5,
                      child: ListView.builder(
                        controller: ScrollController(),
//                        physics: ClampingScrollPhysics(),
                        itemCount: 25,
                        itemBuilder: (context, index0) {
                          return Card(
                              child: Column(
                                  children: <Widget>[
                                    Text("${index0 + 1} "),
                                    ListTile(
                                      title: Text(question[index0]),
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
//                                                  print(grVal);
                                                });
                                              },
                                              activeColor: Colors.greenAccent,
                                              title: Text(
                                                  option[index0][index1])
                                          );
                                        },
                                        shrinkWrap: true,
                                        itemCount: 4,
                                        physics: ClampingScrollPhysics(),
                                      ),
                                    ),
                                  ]
                              )
                          );
                        },
                      ),
                    ),
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
                      Text("Once You Submit You Can\nnot able to attend second time"),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close,color: Colors.red),
                              onPressed: () {
//                        print("pressed Cancel");
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.done_all,color: Colors.green),
                              onPressed: () {
//                        print("pressed Submit");
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

  }// alertUser

  Future<void> progressIndicator(bool isRedirect) async {
    if(isRedirect)
      loadingAnimation(context, '');
    int result = 0;

    for (int i = 0; i < 35; i++)
      if (grVal[i] != answers[i])
        result++;
//    print("Wrong Answer Count = $result");

//    DocumentReference dr = Firestore.instance.collection('appData').document('TestResult');
    var data = {
      'isGivenTest': true,
      'TestResult': 35 - result,
    };
    Future.delayed(const Duration(seconds: 1), () async {
      await Firestore.instance.collection('normalUser').document(
          userData['UID']).updateData(data);
//      print("Test Result  Updated");
      userData['TestResult'] = 25 - result;

      DocumentReference dr = userData['appData'];
      dr.get().then((DocumentSnapshot ds) async {
//        print(ds['Total']);
        total = ds['Total'] + 25 - result;
        users = ds['TotalUser'] + 1;
        var update = {
          'Total': total,
          'TotalUser': users
        };
        await Firestore.instance.collection('appData')
            .document('TestResult')
            .updateData(update);
        final List<BarChartData> dataA = [
          BarChartData("Average - score", charts.ColorUtil.fromDartColor(Colors.pinkAccent),(total/users)),
          BarChartData("Your - score", charts.ColorUtil.fromDartColor(Colors.blueAccent) ,25-result)
        ];
        series = [
          charts.Series(
              data: dataA,
              id: 'Average - score',
              domainFn: (BarChartData series, _) => series.title,
              measureFn: (BarChartData series, _) => series.result,
              colorFn: (BarChartData series, _) => series.barColor,
              labelAccessorFn: (BarChartData series, _) => '${series.result.toStringAsPrecision(4)}'
          ),
        ];
        if(isRedirect) {
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (_) =>
            pieCharts(series, userData['TestResult'].toDouble(), true) ));
        } // if
        setState(() => isLoaded = true);
//        print(isLoaded);
      });
    });
  }// progressIndicator

}