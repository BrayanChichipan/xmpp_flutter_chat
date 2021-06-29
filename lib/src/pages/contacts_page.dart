import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/src/pages/chat_page.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class ContactsPage extends StatefulWidget {

  var _connection;

  ContactsPage({@required connection}){
    this._connection = connection;
  }

  @override
  _ContactsPageState createState() => _ContactsPageState(_connection);
}

class _ContactsPageState extends State<ContactsPage> {

  xmpp.Connection _connection;

  _ContactsPageState(this._connection);

  xmpp.RosterManager _rosterManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rosterManager = xmpp.RosterManager.getInstance(_connection);
  }

  @override
  Widget build(BuildContext context) {
     return StreamBuilder(
        stream: xmpp.MessageHandler.getInstance(_connection).messagesStream,
        builder: (ctx,snap) => ListView.builder(
        itemCount: _rosterManager.getRoster().length,
        itemBuilder: (ctx,i){
          List<xmpp.Buddy> buddys = _rosterManager.getRoster();
          return ListTile(
            title: Text(buddys[i].name),
            subtitle: Text(buddys[i].jid.local),
            leading: Icon(Icons.mark_email_unread),
            onTap: (){
              xmpp.Chat newChat = xmpp.ChatManager.getInstance(_connection).getChat(buddys[i].jid);
              Navigator.push(context, 
                MaterialPageRoute(builder: (BuildContext context) => 
                  ChatPage(chat: newChat)
                )
              );
            },
          );
        },
      ),
    );
  }

  _handleAdd(){
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
              onSubmitted: null,
            ),
          ),
        ),
    );
  }
}