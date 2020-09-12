import '../forms/managerSignUpForm.dart';
import '../forms/cadidateSignUpForm.dart';
import '../UIstuff/loadingAnimation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var width,height;
final FirebaseAuth _auth = FirebaseAuth.instance;

class signUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => signUpState();
}

class signUpState extends State<signUp> {
  String userType = 'Candidate';
  bool selected0 = false, selected1 = true;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
            title: Text("Sign UP",textScaleFactor: 1),
          backgroundColor: Colors.blue[900],
        ),
        body: Card(
          color: Colors.blue[50],
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Welcome in HR Management App !',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22.5),textScaleFactor: 1
                  ),
              ),
              Icon(Icons.people, size: 100),
              Text('Select UserType',textScaleFactor: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selected1 = !selected1;
                          selected0 = !selected0;
                          userType = selected0 ? 'Manager' : 'Candidate';
                        });
                      },
                      child: AnimatedContainer(
                        width: 100,
                        height: 80,
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        decoration: selected0?
                        BoxDecoration(border: Border.all(width: 2,color: Colors.blue[900]),borderRadius: BorderRadius.only(bottomRight: Radius.circular(12))):
                        BoxDecoration(border: Border.all(width: 0)),
                        duration: Duration(microseconds: 400000),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.group),
                            Text('HR Manager',textScaleFactor: 1)
                          ],
                        ),

                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selected0 = !selected0;
                          selected1 = !selected1;
                          userType = selected1 ? 'Candidate' : 'HR Manager';
                        });
                      },
                      child: AnimatedContainer(
                        width: 100,
                        height: 80,
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        decoration: selected1?
                        BoxDecoration(border: Border.all(width: 2,color: Colors.blue[900]),borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12))):
                        BoxDecoration(border: Border.all(width: 0)),
                        duration: Duration(microseconds: 400000),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(Icons.group_add),
                            Text('Candidate',textScaleFactor: 1)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Already User ? ",textScaleFactor: 1),
                    Container(
                      width: 1.2*MediaQuery.of(context).size.width/3,
                      child: OutlineButton(
                        textColor: Colors.blue[900],
                        borderSide: BorderSide(color: Colors.blue[900], width: 1.5),
                        shape: StadiumBorder(),
                        onPressed: () => Navigator.pop(context),
                        child: Text("Sign In",textScaleFactor: 1),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Continue As",textScaleFactor: 1),
                    Container(
                      width: 1.2*MediaQuery.of(context).size.width/3,
                      child: RaisedButton(
                        textColor: Colors.blue[100],
                        shape: StadiumBorder(),
                        onPressed: (){
                          if(selected1)
                            Navigator.push(context, MaterialPageRoute(builder:(context) => CandidateForm()));
//                              else if(selected0)
//                                Navigator.push(context, MaterialPageRoute(builder:(context) => ManagerForm()));
//                              else
//                                Scaffold.of(context).showSnackBar(
//                                  SnackBar(content: Text('Please select UserType'))
//                                );
                        else if(selected0)
                            Navigator.push(context, MaterialPageRoute(builder:(context) => ManagerForm()));
                        },
                        color: Colors.blue[900],
                        child: Text(userType,textScaleFactor: 1),
                      ),
                    )
                  ],
                )
              ],
            ),
            ]
          ),
        )
    );
  }

  Future<bool> signUpWithEmailAndPassword(bool selected, List<String> list, BuildContext context ,String edS, String exS,
      [List skills, List<String> hobbies, String stream, String gender] ) async {
    print(selected);
    print(hobbies);
    loadingAnimation(context, "Creating Your Account...");
    try {
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
              email: list[3], password: list[4])).user;
      if (user != null) {
        user.sendEmailVerification();
//        UserUpdateInfo updateUser = UserUpdateInfo();
//        updateUser.displayName = name;
//        await user.updateProfile(updateUser);
//        user.sendEmailVerification();

        if (selected) {
          print("Selected 0");
          final CollectionReference collectionReference =
              Firestore.instance.collection("firmUser");
          DocumentReference dr = Firestore.instance.collection('appData').document('TestResult');

          var managerDetail = {
            'Details': {
              "job": edS,
              "experience": exS,
//              "education": edS,
            },
            'UID': user.uid,
            'Email': list[3],
            'Contact Number': list[2],
            if(gender.isNotEmpty)
              'Gender': gender,
            'UserType': "HR Manager",
            'isAccActivated': true,
            'DisplayName': list[0],
            'DOB': list[1],
            'SkillsNeeded': hobbies,
            'SkillDescription': list[6],
            'CompanyName': list[5],
            if(stream!=null)
              'CompanyType': stream,
            'RegistrationTime': DateTime.now(),
            'CompanyAddress': "aa"
          };

          print("Manager SignUp");
          await collectionReference.document(user.uid).setData(managerDetail);
          print("poping 0");
          Navigator.pop(context);
          Navigator.pop(context);
          showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) =>
            AlertDialog(
              title: Text("Account created successfully"),
              actions: <Widget>[
                RaisedButton(
                  textColor: Colors.blue[100],
                  color: Colors.blue[900],
                  child: Text('TAKE ME TO SIGN IN'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                ),
              ],
            )
          );
          return true;
    } else if (selected == false) {
          print("Selected 1");
          final CollectionReference collectionReference =
              Firestore.instance.collection("candidates");

          List <String>s  = list.getRange(5, 7).toList();
          print(s);
          var newUserDetail = {
            'Details': {
              "job": stream,
              "experience": exS,
              "education": edS,
            },
            'TechnicalSkills': skills,
            'UID': user.uid,
            'Email': list[3],
            'Contact Number': list[2],
            'Gender': gender,
            'UserType': "Candidate",
            'isAccActivated': true,
            'isGivenPersonality': -1,
            'isGivenTest': false,
            'isStarted': false,
            'DetailsAdded': true,
            'DisplayName': list[0],
            'DOB': list[1],
            'Hobbies': hobbies,
            'Projects': s,
            'RegistrationTime': DateTime.now()
          };
          await collectionReference.document(user.uid).setData(newUserDetail);

          await _auth.signOut();
          print("Candidate SignUp");
//          print(name);
          print("poping 1");
          Navigator.pop(context);
          print("poping 2");
          Navigator.pop(context);
          print("poping 3");
          showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) =>
            AlertDialog(
              title: Text("Account created successfully"),
              actions: <Widget>[
                RaisedButton(
                    textColor: Colors.blue[100],
                    color: Colors.blue[900],
                    child: Text('TAKE ME TO SIGN IN'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                ),
              ],
            )
          );
          return true;
        }
      } else {
        print("else User");
        print("poping 3");
        Navigator.pop(context);
        Navigator.pop(context);
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error during SignUp, Please Try Again'), duration: Duration(seconds: 1),));
        return false;
      }
    } catch (e) {
      print("catch  clause");
      print(e.toString());
      print("poping 5");
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Error on signup'),
            action: SnackBarAction(label: 'Home', onPressed: () => Navigator.pop(context)),
          )
      );
      if (e.message != 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Authentication Error. "),
              content: Text('error : ${e.message}'),
            )
        );
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Neteork Error. "),
                  content: Text("Please conncet your Device to internet."),
                ));
      }
      return false;
    }
    print("poping 6");
    return false;
  }

}
