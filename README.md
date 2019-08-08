Some general points :

1. We have considered that uid and password to be not empty.
2. We have changed the AllConversations servlet - the servlet now returns the name as well.
3. To test the loading screen before chats arrive, we added a sleep statement and commented in final code. (line 39 of AllConversations.dart).
4. There is no facility of scrolling in TypeAheadAPI
5. The word limit for sending messages is 256 letters, the app doesnt give an error - but can be implemented with just one line.

INSTALLATION INSTRUCTIONS:

1. place all the dart files in lib
2. place the AllConversations servlet with other servlets
3. The 'IP' and 'eclipse project name' are in main.dart (line number - 22, 23)
4. psql config to be done in Config.java
