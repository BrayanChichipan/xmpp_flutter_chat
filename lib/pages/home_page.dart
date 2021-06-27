import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/pages/chat_page.dart';
import 'package:flutter_chat_xmpp/pages/usuario_model.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  xmpp.Connection _connection;
  var subsChat;
  var subsState;

  final _usuario = Usuario.getUsuario;

  List<xmpp.Chat> _chats = [];

  xmpp.ChatManager _chatManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var jid = xmpp.Jid.fromFullJid(_usuario.jid);
    var account = xmpp.XmppAccountSettings(_usuario.jid, jid.local, jid.domain, _usuario.password, 5222, resource: 'xmppstone');
    _connection  = xmpp.Connection(account);
    _connection.connect();

    subsState = _connection.connectionStateStream.listen((xmpp.XmppConnectionState state){
    
      print(state);

    });

    _chatManager = xmpp.ChatManager.getInstance(_connection);

    subsChat = _chatManager.chatListStream.listen((List<xmpp.Chat> chats) {

          setState(() {
            _chats.insert(0, chats.last);
          });

    });
  }


  @override
  void dispose() {
    subsChat.cancel();
    subsState.cancel();
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
