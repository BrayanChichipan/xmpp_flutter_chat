import 'package:flutter/material.dart';
import 'package:flutter_chat_xmpp/pages/usuario_model.dart';

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

class FormLogin extends StatelessWidget {

 final formKey = GlobalKey<FormState>();
 final jidController = new TextEditingController();
 final passController = new TextEditingController();

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
          SizedBox(height: 20,),
          RaisedButton(
            child: Text('Login'),
            onPressed: (){
                if(!formKey.currentState.validate()) return ;

                formKey.currentState.save();
                new Usuario(jid: jidController.text,password: passController.text);
                Navigator.pushReplacementNamed(context, 'home');
            },
          )
        ],
      ),
    );
  }
}