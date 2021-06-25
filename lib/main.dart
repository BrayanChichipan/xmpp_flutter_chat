import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/pages/chat_page.dart';
import 'package:flutter_chat_xmpp/pages/home_page.dart';
import 'package:flutter_chat_xmpp/pages/login_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'login' : ( BuildContext context ) => LoginPage(),
        'home' : ( BuildContext context ) => HomePage(),
        'chat' : ( BuildContext context ) => ChatPage(),
      },
    );
  }
}