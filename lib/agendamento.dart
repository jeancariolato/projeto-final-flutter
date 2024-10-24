class Agendamento {
  int? id; // Pode ser nulo se o agendamento ainda não foi salvo no banco
  String nomeResponsavel;
  String data;
  List<String> horariosSelecionados; // Armazenar como uma lista
  double valorTotal;

  Agendamento({
    this.id,
    required this.nomeResponsavel,
    required this.data,
    required this.horariosSelecionados,
    required this.valorTotal,
  });

  // Método para converter um objeto Agendamento em um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeResponsavel': nomeResponsavel,
      'data': data,
      'horariosSelecionados': horariosSelecionados.join(', '), // Converte a lista para string
      'valorTotal': valorTotal,
    };
  }

  // Método para criar um Agendamento a partir de um Map
  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'],
      nomeResponsavel: map['nomeResponsavel'],
      data: map['data'],
      horariosSelecionados: map['horariosSelecionados'].split(', '), // Converte a string de volta para lista
      valorTotal: map['valorTotal'],
    );
  }
}
