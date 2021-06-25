import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/pages/usuario_model.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  xmpp.Connection connection;
  xmpp.MessageHandler messageHandler;
  final usuario = Usuario.getUsuario;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var jid = xmpp.Jid.fromFullJid(usuario.jid);
    var account = xmpp.XmppAccountSettings(usuario.jid, jid.local, jid.domain, usuario.password, 5222, resource: 'xmppstone');
    connection  = xmpp.Connection(account);
    connection.connect();
    messageHandler = xmpp.MessageHandler.getInstance(connection);
    connection.connectionStateStream.listen((xmpp.XmppConnectionState state){
    
      print(state);

    });
    messageHandler.messagesStream.listen((xmpp.MessageStanza message) {
      print('este es el evento');
      print(message.body);
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