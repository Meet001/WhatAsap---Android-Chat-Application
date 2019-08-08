import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'main.dart' ;
import 'dart:convert' as JSON;
import 'ChatDetail.dart';
import 'dart:io' ;
import 'AllConversations.dart' ;

class CreateConversation extends StatefulWidget {
  @override
  _CreateConversationState createState() => _CreateConversationState();
}

class _CreateConversationState extends State<CreateConversation> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Create Conversation'),
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
        child:

        TypeAheadField(

          textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,

              decoration: InputDecoration(
                  hintText: 'Enter Name/ID/Phone',
                  border: OutlineInputBorder()
              )
          ),

          suggestionsCallback: (pattern) async {
//            if (pattern == "") return ; What are we supposed to do here
            String myString = await MyAppState.mySession.get('http://'+MyAppState.ipaddr+
                ':8080/'+MyAppState.servletprojectname+'/AutoCompleteUser?term='+pattern);
            return JSON.jsonDecode(myString);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion['label']),
            //  subtitle: Text('\$${suggestion['price']}'),
            );
          },
          onSuggestionSelected: (suggestion) {
            MyAppState.mySession.get('http://'+MyAppState.ipaddr+':8080/'+MyAppState.servletprojectname+
                '/CreateConversation?other_id=' + suggestion['value']).then((String myString){
              Map conv = JSON.jsonDecode(myString);
              if(conv['status'].toString() == 'true'
              ||
                  conv['message'].toString().contains('ERROR: duplicate key value violates')
              ){
              //  print(conv) ;
               // print(suggestion) ;
              //  print(suggestion['label']);
                String suggestionName = suggestion['label'].toString().split(",")[1].substring(6);
              //  print(suggestionName);
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) {return new ChatDetail(suggestion['value'].toString(),suggestionName);}),
                );
              }

            });
          },
        ),
        ),
    );
  }

}
