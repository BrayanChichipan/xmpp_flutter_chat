
import 'package:xmpp_stone/xmpp_stone.dart' ;

class Usuario {
  static Usuario usuario = new Usuario._();

  String jid   = '';
  String password = '';
  bool logeado    = false;
  XmppAccountSettings account; 
  
  Usuario._();

  factory Usuario( {jid,password,account} ) {
    
    usuario.jid   = jid;
    usuario.password   = password ;
    usuario.account = account;
    
    usuario.logeado  = true;

    return usuario;

  }

  static Usuario get getUsuario {
    return usuario;
  }
}