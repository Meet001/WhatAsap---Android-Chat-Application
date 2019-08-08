import 'package:flutter/material.dart';
import 'dart:io';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'ChatDetail.dart';
import 'main.dart';
import 'CreateConversation.dart';

class AllConversations extends StatefulWidget {
  @override
  _AllConversationsState createState() => _AllConversationsState();
}

class ConversationData {

  final String uid, name, last_timestamp;

  ConversationData({this.uid, this.name, this.last_timestamp});

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return new ConversationData(
      uid: json['uid'].toString(),
      name: json['name'].toString(),
      last_timestamp: json['last_timestamp'].toString(),
    );
  }
}

class _AllConversationsState extends State<AllConversations> {
  Map Conversations;
  bool loading = true;
  String searchkey = "";
  @override
  void initState() {

    MyAppState.mySession.get('http://'+MyAppState.ipaddr+':8080/'+MyAppState.servletprojectname+'/AllConversations').then((String myString){
   //   sleep(new Duration(seconds: 3));
      setState(() {
          Conversations = JSON.jsonDecode(myString);
          loading = false;
        });
      });
      super.initState();
  }



  Widget _buildChild() {
    if (loading) {
      return new Text("Loading");
    }
    else {
     // print(Conversations.toString());
      List<ConversationData> SearchTemp = [];
      if(searchkey.trim() == "" || searchkey == null){

        for(int i = 0;i<Conversations['data'].length;i++){
          //  print(ConversationData.fromJson(Conversations['data'][i]).toString());
            SearchTemp.add(ConversationData.fromJson(Conversations['data'][i]));
        }
      }
      else{
        for(int i = 0;i<Conversations['data'].length;i++){
          String tempName = Conversations['data'][i]['name'].toString().toLowerCase();
          String tempUid = Conversations['data'][i]['uid'].toString().toLowerCase();
          if(tempName.contains(searchkey) || tempUid.contains(searchkey)){
            SearchTemp.add(ConversationData.fromJson(Conversations['data'][i]));
          }
        }
      }
      return new ListView.builder(
          itemCount: SearchTemp.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
            child: new ListTile(
           //   leading: Conversations['data'][index]['uid'],

              leading: new CircleAvatar(child: new Text(SearchTemp[index].name[0].toUpperCase()),backgroundColor: Colors.green,),
              title: new Text(SearchTemp[index].name + "\n" +SearchTemp[index].uid),
              subtitle: new Text(SearchTemp[index].last_timestamp),
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) {return new ChatDetail(SearchTemp[index].uid,SearchTemp[index].name);}),
                );
              },
            ),
              margin: const EdgeInsets.all(0.3),
            );
          }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // key: _scaffoldstate,
      appBar: new AppBar(
        title: new Text('Chats'),
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
      body: new Container(
        //padding: EdgeInsets.all(10.0),
        child: new Center(
          // key: myForm,

          child:Column(
            children: <Widget>[

          new ListTile(
            leading: new Icon(Icons.search),
            title: new TextField(
              decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none),
              onChanged: (String str)
              {
                setState(() {
                  searchkey = str.trim().toLowerCase();
                });
              },
            ),
          ),
             new Expanded(child: _buildChild()),

            ],
          )

          //

          ),
      ),
    );
  }
}
