import 'package:flutter/material.dart';
// Para manipulação de datas

class AgendamentoCard extends StatelessWidget {
  final String nomeResponsavel;
  final String data;
  final String horariosSelecionados;
  final double valorTotal;
  final String esporte;

  const AgendamentoCard({
    super.key,
    required this.nomeResponsavel,
    required this.data,
    required this.horariosSelecionados,
    required this.valorTotal,
    required this.esporte
  });

  
  String _obterMes(String data) {
    String mes = data.split('/')[1]; // Obtém o mês (ex: "10")

    switch (mes) {
      case "01":
        return "JAN";
      case "02":
        return "FEV";
      case "03":
        return "MAR";
      case "04":
        return "ABR";
      case "05":
        return "MAI";
      case "06":
        return "JUN";
      case "07":
        return "JUL";
      case "08":
        return "AGO";
      case "09":
        return "SET";
      case "10":
        return "OUT";
      case "11":
        return "NOV";
      case "12":
        return "DEZ";
      default:
        return ""; // Retorna vazio se o mês não for válido
    }
  }

  @override
Widget build(BuildContext context) {
  String mes = _obterMes(data);

  // Obtém as dimensões da tela
  final screenSize = MediaQuery.of(context).size;

  return Card(
    margin: const EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // DATA
          Container(
            width: screenSize.width * 0.2, // Ajusta a largura do contêiner para 20% da largura da tela
            height: screenSize.height * 0.1, // Ajusta a altura do contêiner para 10% da altura da tela
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 102, 0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza o conteúdo verticalmente
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data.split('/')[0], // Aqui você pode alterar para pegar o dia real da data
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.width * 0.07, // Ajusta o tamanho da fonte do dia
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  mes, // Aqui você pode alterar para pegar o mês real da data
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.width * 0.04, // Ajusta o tamanho da fonte do mês
                  ),
                ),
              ],
            ),
          ),
          // NOME E VALOR
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nomeResponsavel,
                style: TextStyle(
                  fontSize: screenSize.width * 0.05, // Ajusta o tamanho da fonte do nome
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                esporte,
                style: TextStyle(
                  fontSize: screenSize.width * 0.04, // Ajusta o tamanho da fonte do valor total
                ),
              ),
            ],
          ),
          // HORÁRIOS FORMATADOS
          Text(
            horariosSelecionados,
            style: TextStyle(
              fontSize: screenSize.width * 0.03, // Ajusta o tamanho da fonte dos horários
            ),
          ),
        ],
      ),
    ),
  );
}
}
