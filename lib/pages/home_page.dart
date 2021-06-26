import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/pages/usuario_model.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  xmpp.Connection _connection;
  xmpp.MessageHandler _messageHandler;

  final _usuario = Usuario.getUsuario;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var jid = xmpp.Jid.fromFullJid(_usuario.jid);
    var account = xmpp.XmppAccountSettings(_usuario.jid, jid.local, jid.domain, _usuario.password, 5222, resource: 'xmppstone');
    _connection  = xmpp.Connection(account);
    _connection.connect();

    _messageHandler = xmpp.MessageHandler.getInstance(_connection);
    
    _connection.connectionStateStream.listen((xmpp.XmppConnectionState state){
    
      print(state);

    });
    _messageHandler.messagesStream.listen((xmpp.MessageStanza message) {
      print('este es el evento');
      print(message.body);
    });

    xmpp.ChatManager.getInstance(_connection).chatListStream.listen((List<xmpp.Chat> chats) {

      chats.forEach((chat) { 
        print('tienes un mensaje de ${chat.jid.local}');
      });

    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contactos'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (ctx,i){
            return ListTile(
              title: Text('mensaje'),
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.charging_station_rounded),
        onPressed: (){
          final jid = xmpp.Jid.fromFullJid('flutter_test1@jabjab.de');
          _messageHandler.sendMessage(jid, 'hola flutter_test1 pa mi mismo');
        }
      ),
    );
  }
}