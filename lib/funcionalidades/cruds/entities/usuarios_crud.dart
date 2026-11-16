class UsuariosCrud {
  int usuNumMatricula;
  String usuNome;
  String usuSobrenome;
  String usuEmail;
  String usuSenha;
  String usuCurso;
  String usoTelefone = "";
  String usoImgPerfil = "";

  UsuariosCrud(
      this.usuNumMatricula,
      this.usuNome,
      this.usuSobrenome,
      this.usuEmail,
      this.usuSenha,
      this.usuCurso,
      this.usoTelefone,
      this.usoImgPerfil);

  @override
  String toString() {
    return 'UsuariosCrud{usuNumMatricula: $usuNumMatricula, usuNome: $usuNome, usuSobrenome: $usuSobrenome, usuEmail: $usuEmail, usuSenha: $usuSenha, usuCurso: $usuCurso, usoTelefone: $usoTelefone, usoImgPerfil: $usoImgPerfil}';
  }
}
