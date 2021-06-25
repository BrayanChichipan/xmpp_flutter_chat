
class Usuario {
  static Usuario usuario = new Usuario._();

  String jid   = '';
  String password = '';
  bool logeado    = false;
  
  Usuario._();

  factory Usuario( {jid,password} ) {
    
    usuario.jid   = jid;
    usuario.password   = password ;
    
    usuario.logeado  = true;

    return usuario;

  }

  static Usuario get getUsuario {
    return usuario;
  }
}