import 'package:flutter/material.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var connection;
  var messageHandler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var jid = xmpp.Jid.fromFullJid('flutter_test1@jabjab.de');
    var account = xmpp.XmppAccountSettings('flutter_test1@jabjab.de', jid.local, jid.domain, '1q2w3e4r5t', 5222, resource: 'xmppstone');
    connection  = xmpp.Connection(account);
    connection.connect();
    messageHandler = xmpp.MessageHandler.getInstance(connection);
    connection.connectionStateStream.listen((xmpp.XmppConnectionState state){
    
      print(state);

    });
    messageHandler.messagesStream.listen((event) {
      print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('home'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.charging_station_rounded),
        onPressed: (){
          final jid = xmpp.Jid.fromFullJid('flutter_test1@jabjab.de');
          messageHandler.sendMessage(jid, 'hola flutter_test1');
        },
      ),
    );
  }
}