import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/src/models/usuario_model.dart';
import 'package:flutter_chat_xmpp/src/pages/chats_page.dart';
import 'package:flutter_chat_xmpp/src/pages/contacts_page.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class HomePage extends StatefulWidget {

  var _connection;

  HomePage({@required connection}){
    this._connection = connection;
  }

  @override
  _HomePageState createState() => _HomePageState(_connection);
}
class _HomePageState extends State<HomePage> {

  xmpp.Connection _connection;

  _HomePageState(this._connection);

  int _currentIndex = 0;

  List<Widget> _pages = [];

  @override
  void initState() { 
    super.initState();
    _pages.add(ChatsPage(connection: _connection));
    _pages.add(ContactsPage(connection: _connection));
  }

  @override
  void dispose() {
    _connection.close();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green[900],
        backgroundColor: Colors.grey.shade300,
        currentIndex: _currentIndex, //que elemento esta activo
        onTap: (index) {
          // posicion de boton del navigation
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat,color: Colors.green[300],),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page,color: Colors.green[300],),
            label: 'Contactos',
          ),
        ],
     ),
    );
  }
}
