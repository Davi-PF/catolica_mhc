class CertificadosCrud {
  int id;
  int numeroDeMatricula;
  String nomeDoCurso;
  String instituicao;
  String tipoCertificado;
  String status;
  double cargaHoraria;
  String motivo;
  String imagem;

  CertificadosCrud(
      this.id,
      this.numeroDeMatricula,
      this.nomeDoCurso,
      this.instituicao,
      this.tipoCertificado,
      this.status,
      this.cargaHoraria,
      this.motivo,
      this.imagem);

  @override
  String toString() {
    return 'CertificadosCrud{id: $id, numeroDeMatricula: $numeroDeMatricula, nomeDoCurso: $nomeDoCurso, instituicao: $instituicao, tipoCertificado: $tipoCertificado, status: $status, cargaHoraria: $cargaHoraria, motivo: $motivo, imagem: $imagem}';
  }
}
