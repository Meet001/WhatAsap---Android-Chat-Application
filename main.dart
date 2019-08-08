import 'package:flutter/material.dart';
import 'dart:async';
import 'AllConversations.dart';
import 'session.dart';
import 'dart:convert' as JSON;

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner : false,
      home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget{
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp>{
  String _userid = "";
  String _password = "";
  static String ipaddr = '10.130.154.58';
  static String servletprojectname = 'whatasap';

  static Session mySession = new Session();

  final myForm = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
//  void _onChangeUserid(String value){
//    setState(){
//      _userid = value;
//      print("lolchanged");
//    }
//
//  }
//
//  void _onChangePassword(String value){
//    setState(){
//      _password = value;
//    }
//  }

  void myPress(){

    final form = myForm.currentState;

    form.save();
    
    if(form.validate()){
   //  print(_userid );
    // print(_password);
     checkLogin();
    }

  }



  Future checkLogin() async {

    Map body = {"userid":_userid,"password":_password};
    final str1 = await mySession.post('http://'+ipaddr+':8080/'+servletprojectname+'/LoginServlet',body);
    Map loginStatus = JSON.jsonDecode(str1);
  //  print(loginStatus.toString());

    if(loginStatus['status'].toString() == 'true')
      {
        Navigator.pushReplacement (
          context,
          new MaterialPageRoute(builder: (context) {return new AllConversations();}),
        );
      }
      else
        {
            _scaffoldstate.currentState.showSnackBar(new SnackBar(content: new Text("Login Failed")));
        }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldstate,
        appBar: new AppBar(
        title: new Text('Login Page'),
    ),
    body: new Container(
      padding: EdgeInsets.all(10.0),
    child: new Form(
      key: myForm,
      child: new Column(
      children: <Widget>[
        new TextFormField(
          decoration: new InputDecoration(labelText: "User ID"),
          validator: (value) => value.isEmpty ? 'User ID can\'t be empty' : null,
          onSaved: (value) => _userid = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: "Password"),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      new RaisedButton(
      onPressed: myPress,
    child: new Text('LOGIN'),
    ),
    ],
    ),
    ),
    ),
    );
    }
  }


