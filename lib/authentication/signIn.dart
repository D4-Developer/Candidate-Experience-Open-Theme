import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../HR_Manager/home_HR-Manager.dart';
import 'signUpPage.dart';
import '../Candidate/home_candidate.dart';
import '../UIstuff/loadingAnimation.dart';

final GlobalKey<FormState> _formKey0 = GlobalKey<FormState>();
final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
var scaleFactor;
TextStyle formStyle = TextStyle(color: Colors.blue[900], fontSize: 17/scaleFactor,fontWeight: FontWeight.bold,fontFamily: 'Times New Roman');

class signIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => signInState();
}


class signInState extends State<signIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool selected0=true,selected1=false,field0=false,field1=false;

  String welcomeText = 'Manager';

  Future<void> _signInWithEmailAndPassword() async {
    bool _success;

    if (_formKey0.currentState.validate() && _formKey1.currentState.validate() ) {
      loadingAnimation(context, "Loading...");
//      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;

        final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
                                email: _emailController.text, password: _passwordController.text)
                               ).user;
        if (user != null) {

          if (user.isEmailVerified) {
            user.displayName;
            if (selected0) {
              CollectionReference collectionReference = Firestore.instance.collection('firmUser');
              try{
                 await collectionReference
                  .document(user.uid)
                  .get()
                  .then((DocumentSnapshot ds) async { // use ds as a snapshot
                // use ds as a snapshot
                   if (ds.exists){
                var UserData = ds.data;
                if (UserData['UserType'] == 'HR Manager') {
                  Navigator.pop(context);
                  print ('data fetch Successfully');

                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => Homep(UserData,_auth)));
                }
                   }
                else {
                     Navigator.pop(context);
                     showDialog(
                         context: context,
                         builder: (context) =>
                             AlertDialog(
                               title: Text("Error : User Not Exists As HR Manager"),
                               content: Text("Change Your UserType Selection Or Register with Us. "),
                             )
                     );
                     await _auth.signOut();
                }
              });
              }
              catch(e){
                print("catch clause");
                print("I got this error " + e.message);
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text("Error : User Not Exists As Candidate"),
                          content: Text("Change Your UserType Selection Or Register with Us. "),
                        )
                );
                await _auth.signOut();
              }

            } // if selected0
            else if(selected1){
              print(" Candidate : "+ selected1.toString() );
              try {
                await Firestore.instance
                    .collection('candidates')
                    .document(user.uid)
                    .get()
                    .then((DocumentSnapshot ds) async { // use ds as a snapshot
                  // use ds as a snapshot
                  var UserData = ds.data;
                  //print("printing userdata "+UserData.toString());
                  if (UserData!=null){
                    if(UserData['UserType'] == 'Candidate' ) {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => homeCandidate(UserData,_auth)));
                      print("after push");
                    }
                  }
                  else {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: Text("Error : User Not Exists As Candidate"),
                              content: Text("Change Your UserType Selection Or Register with Us. "),
                            )
                    );
                    await _auth.signOut();
                  }
                });
              }catch(e){
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text("Error : User Not Exists As Candidate"),
                          content: Text(
                              "Change Your UserType Selection Or Register with Us. "),
                        )
                );
                await _auth.signOut();
              }
            }
          } // is Email Verified....
            else {
            Navigator.pop(context);
              user.sendEmailVerification();
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text("Email-Verification"),
                        content: Text(
                            "Email is not verified. Please check your Mail for varification"),
                      )
              );
              await _auth.signOut();
            }
            _formKey0.currentState.reset();
            _formKey1.currentState.reset();

        } else {
          setState(() {
            _success = true;
          });
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text("Error : User Not Exists"),
                    content: Text("Register with Us. "),
                  )
          );
        }
        //print("signed in " + user.uid);
      } catch (e) {
        print(e.message);
        Navigator.pop(context);
        if(e.message != 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text("Authentication Error. "),
                    content: Text(e.message),
                  )
          );
        }
        else{
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text("Neteork error"),
                    content: Text("Please conncet your Device to Internet."),
                  )
          );
        }
      }
    }
  }   // future signInWithEmailPassword()....

  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In', textScaleFactor: 1),
        backgroundColor: Colors.blue[900],
        automaticallyImplyLeading: false,
      ),
      body: Card(
//        height: height,
            color: Colors.blue[50],
            child:
          Container(
            height: height,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                     padding: EdgeInsets.only(top: width/12),
                   alignment: Alignment.center,
                     child: Text('Welcome $welcomeText !', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),textScaleFactor: 1,)
                 ),
                 Container(
                     padding: EdgeInsets.only(top: width/12),
                     child: Icon(Icons.group, size: 50/scaleFactor)
                 ),
                 Padding(padding: EdgeInsets.only(top: width/10)),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           selected1 = !selected1;
                           selected0 = !selected0;
                           welcomeText = selected0 ? 'Manager' : 'Candidate';
                         });
                       },
                       child: AnimatedContainer(
                         width: 100,
                         height: 80,
                         padding: EdgeInsets.all(0),
                         margin: EdgeInsets.all(0),
                         decoration: selected0?
                         BoxDecoration(border: Border.all(width: 2,color: Colors.blue[800]),borderRadius: BorderRadius.only(bottomRight: Radius.circular(12))):
                         BoxDecoration(border: Border.all(width: 0)),
                         duration: Duration(microseconds: 400000),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             //crossAxisAlignment: CrossAxisAlignment.center,
                             children: <Widget>[
                               Icon(Icons.group),
                               Text('HR Manager', textScaleFactor: 1)
                             ],
                           ),

                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                         setState(() {
                           selected0 = !selected0;
                           selected1 = !selected1;
                           welcomeText = selected1 ? 'Candidate' : 'Manager';
                         });
                       },
                       child: AnimatedContainer(
                         width: 100,
                         height: 80,
                         padding: EdgeInsets.all(0),
                         margin: EdgeInsets.all(0),
                         decoration: selected1?
                         BoxDecoration(border: Border.all(width: 2,color: Colors.blue[800]),borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12))):
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
                   ],
                 ),
//               Container(padding: EdgeInsets.only(top: 50),),
                 Container(padding: EdgeInsets.only(top: width/12)),
                 Form(
                   key: _formKey0,
                   child: ListTile(
                     trailing: field0 ? Icon(Icons.error_outline, color: Colors.red,): null,
                     title:
                       TextFormField(
                         keyboardType: TextInputType.emailAddress,
                         toolbarOptions: ToolbarOptions(paste: true),
                         maxLines: 1,
                         controller: _emailController,
                         style: formStyle,
                         decoration: InputDecoration(
                           labelText: 'Email',
                           labelStyle: formStyle,
                           border: InputBorder.none,
                           focusedBorder: InputBorder.none,
                           icon: Icon(Icons.mail, color: Colors.blue[900]),
  //                          contentPadding: EdgeInsets.fromLTRB(2,25,2,5),
                         ),
                         validator: (String value) {
                         if (value.isEmpty){
                           setState(() =>field0 = true);
                           return 'Enter Email';
                         }
                         else if(!(value.contains('@', 1))) {
                           setState(() =>field0 = true);
                           return "Email must contains '@'";
                         }
                         setState(() => field0 = false);
                         return null;
                         },
                         onEditingComplete: () {
                         if(_formKey0.currentState.validate()) {
                           FocusScope.of(context).nextFocus(); /// Transfer Focus to next TextFormField....
                           setState(() {
                             field0 = false;
                           });
                         }
                         else
                           setState(() {field0 = true;});
                         },
                       ),
                   ),
                 ),
                 Form(
                   key: _formKey1,
                   child: ListTile(
                       trailing: field0 ? Icon(Icons.error_outline, color: Colors.red,): null,
                       title: TextFormField(
                         style: formStyle,
                         textInputAction: TextInputAction.next,
                         toolbarOptions: ToolbarOptions(),
                         obscureText: true,
                         controller: _passwordController,
                         maxLines: 1,
                         decoration: InputDecoration(
                           labelText: 'Password',
                           labelStyle: formStyle,
                           border: InputBorder.none,
                           focusedBorder: InputBorder.none,
                           icon: Icon(Icons.lock, color: Colors.blue[900],),
                         ),
                         validator: (String value) {
                           if(value.length < 8){
                             setState(() => field1 = false);
                             return 'Password must be 8 characters long';
                           }
                           setState(() => field1 = true);
                           return null;
                         },
                         onEditingComplete: () {
                           if(_formKey1.currentState.validate()) {
                             FocusScope.of(context).unfocus(); /// removes the keyboard focus from screen....
                             setState(() {
                               field1 = true;
                             });
                           }
                           else
                             setState(() {field1 = true;});
                         },
                       )
                   ),
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: <Widget>[
                     Text('New User ? '),
                     OutlineButton(
                       borderSide: BorderSide(color: Colors.blue[900]),
                       shape: StadiumBorder(),
                         child: Text('Sign Up', style: TextStyle(color: Colors.blue[900]),textScaleFactor: .9),
                         onPressed: () {
                           _formKey0.currentState.reset();
                           _formKey1.currentState.reset();
                           Navigator.push(context, MaterialPageRoute(builder: (context) => signUp()));
                         }
                     ),
                     Padding(padding: EdgeInsets.only(right: 5),)
                   ],
                 ),
                 Container(
                   padding: EdgeInsets.only(top: width/50),
                   width: 1.3*MediaQuery.of(context).size.width/3,
                   child: RaisedButton(
                     textColor: Colors.blue[100],
                     shape: StadiumBorder(),
                     color: Colors.blue[900],
                     child: const Text('LOGIN'),
                     onPressed: () {
                       _signInWithEmailAndPassword();
                     },
                   ),
                 ),
               ]
              ),
            ),
          ),
        )
    );
  }
}