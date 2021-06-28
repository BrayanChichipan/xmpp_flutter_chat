import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/pages/home_page.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login',style: TextStyle(color: Colors.blue, fontSize: 30),),
                FormLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormLogin extends StatefulWidget {

  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController jidController = new TextEditingController();

  final TextEditingController passController = new TextEditingController();

  bool _loading = false;
  bool _error = false;

  @override
  void dispose(){
    jidController?.dispose();
    passController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: jidController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'jid',
              icon: Icon(Icons.alternate_email),
            ),
            validator: (jid){
              if(jid.length > 8){
                return null;
              }
              return 'verifique este campo';
            },
          ),
          TextFormField(
            controller: passController,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'contraseña',
              icon: Icon(Icons.lock),
            ),
            validator:(pass){
              if(pass.length > 6){
                return null;
              }
              return 'verifique este campo';
            },
          ),
          SizedBox(height: 10,),
          if(_error) Text('Error con autenticación: verifique sus datos',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w100, fontSize: 12),
                        ),
          SizedBox(height: 20,),
          _loading
            ?CircularProgressIndicator()
            :RaisedButton(
              child: Text('Login'),
              color: Colors.blue[100],
              onPressed: ()=>_handleLogin(context),
            ),
        ],
      ),
    );
  }

  _handleLogin(BuildContext context){
    if(!formKey.currentState.validate()) return ;

    formKey.currentState.save();

    setState(() {
      _loading = true;
    });

    final jid = xmpp.Jid.fromFullJid(jidController.text);
    final account = xmpp.XmppAccountSettings(jid.userAtDomain, jid.local, jid.domain, passController.text, 5222, resource: 'xmppstone');
    final _connection  = xmpp.Connection(account);

    _connection.connect();

    _connection.connectionStateStream.listen((xmpp.XmppConnectionState state){

    if(state == xmpp.XmppConnectionState.Ready){
        Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (BuildContext context) => 
            HomePage(connection: _connection))
        );
    }else if(state == xmpp.XmppConnectionState.AuthenticationFailure){
      setState(() {
      _loading = false;
      _error = true;
    });
      print('verificar datos');
    }

    });
  }
}