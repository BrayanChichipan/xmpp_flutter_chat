import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/src/pages/chat_page.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class ChatsPage extends StatefulWidget {

  var _connection;

  ChatsPage({@required connection}){
    this._connection = connection;
  }

  @override
  _ChatsPageState createState() => _ChatsPageState(_connection);
}

class _ChatsPageState extends State<ChatsPage> {

  final xmpp.Connection _connection;

  _ChatsPageState(this._connection);

  
  xmpp.ChatManager _chatManager;

  @override
  void initState() { 
    super.initState();
    _chatManager = xmpp.ChatManager.getInstance(_connection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        centerTitle: true,
        title: Text('Chats',style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder(
        stream: xmpp.MessageHandler.getInstance(_connection).messagesStream,
        builder: (ctx,snap) => ListView.builder(
          itemCount: _chatManager.chats.length,
          itemBuilder: (ctx,i){
            return ListTile(
              title: Text(_chatManager.chats[i].jid.local),
              subtitle: 
                (_chatManager.chats[i].messages.length != 0)
                  ?Text(_chatManager.chats[i].messages.last.text)
                  :Text(''),
              leading: Icon(Icons.mark_email_unread),
              onTap: (){
                Navigator.push(context, 
                  MaterialPageRoute(builder: (BuildContext context) => 
                    ChatPage(chat: _chatManager.chats[i])
                  )
                );
              },
            );
          },
        ),
      ),
    );
  }
}