import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/pages/usuario_model.dart';
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

  xmpp.Jid xjidDes;
  String jidDest;
  xmpp.Connection _connection;
  
  xmpp.MessageHandler _messageHandler;

  List<MessageChat> _messages = [];

  TextEditingController _messageController = TextEditingController();

  var subs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    xjidDes = xmpp.Jid.fromFullJid(jidDest);

    _messageHandler = xmpp.MessageHandler.getInstance(_connection);

     subs = _messageHandler.messagesStream.listen((xmpp.MessageStanza message) {
      if( message.fromJid.fullJid == this.jidDest ){
        setState(() {
        _messages.insert(0,MessageChat(jid: message.fromJid.fullJid,text: message.body));
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _messageController?.dispose();
    subs.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.jidDest),
      ),
      body: Container(
        color: Colors.black12,
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                
                itemCount: _messages.length,
                itemBuilder: (ctx,i) => _messages[i],
                reverse: true,
              )
            ),
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  _inputMessage(),
                  IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.send),
                    onPressed: _handleSend
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  _handleSend(){

    if(_messageController.text.length > 0){

      _messageHandler.sendMessage(xjidDes,_messageController.text);
      _messages.insert(0,MessageChat(jid:Usuario.getUsuario.jid,text:_messageController.text));
      setState(() {
        _messageController.text = '';
      });
    }

  }

  Widget _inputMessage(){
    return Flexible(
      child: SafeArea(
          child: Container(
          height: 40,
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Escribe'
            ),
          ),
        ),
      ),
    );
  }
}

class MessageChat extends StatelessWidget {
  
  final String text;
  final String jid;

  const MessageChat({Key key, this.text, this.jid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (jid == Usuario.getUsuario.jid)
      ? Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          margin: EdgeInsets.only(bottom: 5,left: 100,right: 5),
          decoration: BoxDecoration(
            color: Colors.green[300],
            borderRadius: BorderRadius.circular(100)
          ),
          child: Text(text,style: TextStyle(color: Colors.white),),
        ),
      )
      :Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          margin: EdgeInsets.only(bottom: 5,left: 5,right: 100),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100)
          ),
          child: Text(text),
        ),
      );
  }
}