import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/pages/chat_page.dart';
import 'package:flutter_chat_xmpp/pages/usuario_model.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class HomePage extends StatefulWidget {

  xmpp.Connection _connection;

  HomePage({@required xmpp.Connection connection}){
    this._connection = connection;
  } 

  @override
  _HomePageState createState() => _HomePageState(_connection);
}
class _HomePageState extends State<HomePage> {

  xmpp.Connection _connection;
  xmpp.ChatManager _chatManager;

  _HomePageState(this._connection);

  var subsChat;
  var subsState;
  var subsMessages;

  List<xmpp.Chat> _chats = [];

  @override
  void initState() {
    super.initState();
    new Usuario(jid:_connection.account.fullJid.userAtDomain,password:_connection.account.password);
    subsMessages = xmpp.MessageHandler.getInstance(_connection).messagesStream
      .listen((event) => setState((){}));
    
    _chatManager = xmpp.ChatManager.getInstance(_connection);
    subsChat = _chatManager.chatListStream.listen((List<xmpp.Chat> chats) {
                  _chats.insert(0, chats.last);
                  if(chats.last.messages.isNotEmpty) setState(() {});
    });

  }


  @override
  void dispose() {
    subsChat.cancel();
    subsState.cancel();
    subsMessages.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _chats.length,
          itemBuilder: (ctx,i){
            return ListTile(
              title: Text(_chats[i].messages.last.text),
              subtitle: Text(_chats[i].jid.fullJid),
              leading: Icon(Icons.mark_email_unread),
              onTap: (){
                Navigator.push(context, 
                  MaterialPageRoute(builder: (BuildContext context) => 
                    ChatPage(chat: _chats[i])
                  )
                );
              },
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(
            context: context,
            builder:(BuildContext context) => 
              AlertDialog(
                content: Container(
                  height: 100,
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Ingresa el jid'
                    ),
                    onSubmitted: (String jid){
                        if(jid.trim().length > 7){
                          
                          final xjid = xmpp.Jid.fromFullJid(jid);
                          final xmpp.Chat newChat = _chatManager.getChat(xjid);

                          Navigator.push(context, 
                            MaterialPageRoute(builder: (BuildContext context) => 
                              ChatPage(chat: newChat)
                            )
                          );
                          
                        }
                    },
                  ),
                ),
              ),
          );
        }
      ),
    );
  }
}
