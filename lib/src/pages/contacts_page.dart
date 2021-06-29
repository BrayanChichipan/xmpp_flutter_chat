import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/src/models/usuario_model.dart';
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
    _rosterManager = xmpp.RosterManager.getInstance(_connection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey.shade300,
            centerTitle: true,
            title: Text('Contacts',style: TextStyle(color: Colors.black))
          ),
          body: StreamBuilder(
          stream: _rosterManager.rosterStream,
          builder: (ctx,snap) => 
            ListView.builder(
              itemCount: _rosterManager.getRoster().length,
              itemBuilder: (ctx,i){
                List<xmpp.Buddy> buddys = _rosterManager.getRoster();
                return ListTile(
                  title: Text(buddys[i].name),
                  subtitle: Text(buddys[i].jid.local),
                  leading: Icon(Icons.contact_mail_sharp),
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
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            child: Icon(Icons.add,),
            onPressed: _handleAdd
          ),
        );
  }

  _handleAdd(){

    final key = GlobalKey<FormState>();

    TextEditingController jidController = TextEditingController();
    TextEditingController nombreController = TextEditingController();

    showDialog(
      context: context,
      builder:(BuildContext context) => 
        AlertDialog(
          content: Container(
            height: 230,
            child: Form(
              key: key,
              child: Column(
                children: [
                  TextFormField(
                    controller: jidController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Ingresa el jid'
                    ),
                    validator: (String jid){
                        if(jid.length > 7)
                          return null;
                        return 'verifique el jid';
                    },
                  ),
                  TextFormField(
                    controller: nombreController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Nombre'
                    ),
                    validator: (String nombre){
                        if(nombre.length > 0)
                          return null;
                        return 'Ingresa un nombre';
                    },
                  ),
                  SizedBox(height: 10,),
                  RaisedButton(
                    child: Text('Agregar'),
                    onPressed: (){
                      if(!key.currentState.validate()) return;
                      
                      xmpp.Jid jidContact = xmpp.Jid.fromFullJid(jidController.text);
                      xmpp.Buddy contact = xmpp.Buddy(jidContact);
                      contact.name = nombreController.text;
                      _rosterManager.addRosterItem(contact);
                      _rosterManager.queryForRoster();
                      Navigator.pop(context);
                    }
                  )
                ],
              )
              )
          ),
        ),
    );
  }
}