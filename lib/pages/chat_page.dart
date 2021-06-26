import 'package:flutter/material.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class ChatPage extends StatefulWidget {

  String jidDest;
  xmpp.Connection _connection;

  ChatPage( {@required String jidDest, @required xmpp.Connection connection} ){
    this.jidDest = jidDest;
    this._connection = connection;
  }


  @override
  _ChatPageState createState() => _ChatPageState(this.jidDest,this._connection);
}

class _ChatPageState extends State<ChatPage> {

  _ChatPageState(this.jidDest,this._connection);

  String jidDest;
  xmpp.Connection _connection;
  xmpp.MessageHandler _messageHandler;
  xmpp.Jid xjidDes;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    xjidDes = xmpp.Jid.fromFullJid('flutter_test1@jabjab.de');

    _messageHandler = xmpp.MessageHandler.getInstance(_connection);

    _messageHandler.messagesStream.listen((xmpp.MessageStanza message) {
      print('este es el evento');
      print(message.body);
    });


  }

  @override
  void dispose() {
  super.dispose();
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.jidDest),
      ),
      body: Center(
        child: Text('chat'),
      ),
    );
  }
}