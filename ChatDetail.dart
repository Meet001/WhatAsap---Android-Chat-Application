import 'package:flutter/material.dart';
import 'dart:io';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'main.dart';
import 'CreateConversation.dart' ;
import 'AllConversations.dart' ;

class ChatDetail extends StatefulWidget {

  static String _otherId ;
  static String _name ;

  ChatDetail(String s1, String s2)
  {
    _otherId = s1 ;
    _name = s2 ;
  }

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class ChatDetailData {

  final String uid, name, lastTimestamp;

  ChatDetailData({this.uid, this.name, this.lastTimestamp});

  factory ChatDetailData.fromJson(Map<String, dynamic> json) {
    return new ChatDetailData(
      uid: json['uid'].toString(),
      name: json['name'].toString(),
      lastTimestamp: json['last_timestamp'].toString(),
    );
  }
}

class _ChatDetailState extends State<ChatDetail> {
  Map detail;
  bool loading = true;
  String newMsg = "";

  @override
  void initState() {
   // print(ChatDetail._otherId);
   // print(ChatDetail._name);
    MyAppState.mySession.get('http://'+MyAppState.ipaddr+':8080/'+MyAppState.servletprojectname+'/ConversationDetail?other_id=' + ChatDetail._otherId).then((String myString){
      setState(() {
    //    print(myString);
        detail = JSON.jsonDecode(myString);
        loading = false;
      });
    });
    super.initState();
  }

  void sendMessage(){
    MyAppState.mySession.get('http://'+MyAppState.ipaddr+':8080/'+MyAppState.servletprojectname+'/NewMessage?other_id=' + ChatDetail._otherId +'&msg='+ newMsg).then((String myString){
   //   print(myString);
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (context) {return new ChatDetail(ChatDetail._otherId,ChatDetail._name);}),
      );
    });
  }

  Widget _buildChild() {
    if (loading) {
      return new Text("Loading");
    }
    else {
      return new ListView.builder(
          itemCount: detail['data'].length,
          itemBuilder: (BuildContext context, int index) {
            if (detail['data'][index]['uid'] == ChatDetail._otherId) {
              return new Card(
                child: new ListTile(
                  //   leading: Conversations['data'][index]['uid'],

                  title: new Text(
                      detail['data'][index]['text']),
//                  subtitle: new Text(detail[index].lastTimestamp),
                ),
                margin: const EdgeInsets.only(left:0.3,right:100.0,top:0.3,bottom:0.3),
                color: Colors.cyan ,
              );
            }
            else
            {
              return new Card(
                child: new ListTile(
                  //   leading: Conversations['data'][index]['uid'],

                  title: new Text(
                      detail['data'][index]['text']),
//                    subtitle: new Text(detail[index].lastTimestamp),
                ),
                margin: const EdgeInsets.only(left:100.0,right:0.3,top:0.3,bottom:0.3),
                color: Colors.teal,
              );
            }
          }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // key: _scaffoldstate,
      appBar: new AppBar(
        title: new Text(ChatDetail._name),
        actions: <Widget>[
          // action button
          IconButton(
            icon: new Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement (
                context,
                new MaterialPageRoute(builder: (context) {return new AllConversations();}),
              );
            },
          ),
          // action button
          IconButton(
            icon: new Icon(Icons.create),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(builder: (context) {return new CreateConversation();}),
              );
            },
          ),
          IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: () {
              MyAppState.mySession.get('http://'+MyAppState.ipaddr+':8080/'+MyAppState.servletprojectname+'/LogoutServlet').then((String myString){
                exit(0);
              });
            },
          ),

        ],
      ),
      body:

      new Container(
        //padding: EdgeInsets.all(10.0),
        child: new Center(
          // key: myForm,

            child:Column(
                children: <Widget>[


                  new Expanded(child: _buildChild()),
                  new ListTile(
                    trailing: new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () {
                    //    print("Sending msg");
                         sendMessage();
                      },
                    ),
                    title: new TextField(
                      decoration: new InputDecoration(
                          hintText: 'Enter Message', border: InputBorder.none),
                      onChanged: (String str)
                      {
                          newMsg = str;
                     //     print(newMsg);
                      },

                    ),
                  ),
                ],
            )

          //

        ),
      ),
    );
  }
}


