class Agendamento {
  int? id; 
  String nomeResponsavel;
  String data;
  List<String> horariosSelecionados;
  double valorTotal;
  String esporte;

  Agendamento({
    this.id,
    required this.nomeResponsavel,
    required this.data,
    required this.horariosSelecionados,
    required this.valorTotal,
    required this.esporte
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeResponsavel': nomeResponsavel,
      'data': data,
      'horariosSelecionados': horariosSelecionados.join(', '), 
      'valorTotal': valorTotal,
      'esporte': esporte
    };
  }

  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'],
      nomeResponsavel: map['nomeResponsavel'],
      data: map['data'],
      horariosSelecionados: map['horariosSelecionados'].split(', '), 
      valorTotal: map['valorTotal'],
      esporte: map['esporte']
      
    );
  }
}
