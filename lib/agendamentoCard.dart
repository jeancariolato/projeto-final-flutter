import 'package:flutter/material.dart';
// Para manipulação de datas

class AgendamentoCard extends StatelessWidget {
  final String nomeResponsavel;
  final String data;
  final String horariosSelecionados;
  final double valorTotal;

  const AgendamentoCard({
    super.key,
    required this.nomeResponsavel,
    required this.data,
    required this.horariosSelecionados,
    required this.valorTotal,
  });

  
  String _obterMes(String data) {
    //Obter apenas segunda parte da String 'data' (no caso mês)
    String mes = data.split('/')[1]; 

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
        return "";
    }
  }

  @override
Widget build(BuildContext context) {
  String mes = _obterMes(data);

  // Obter tela total
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
            width: screenSize.width * 0.2, 
            height: screenSize.height * 0.1,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 102, 0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data.split('/')[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.width * 0.07, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  mes, 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.width * 0.04, 
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
                  fontSize: screenSize.width * 0.05, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "R\$${valorTotal.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: screenSize.width * 0.04, 
                ),
              ),
            ],
          ),
          // HORÁRIOS FORMATADOS
          Text(
            horariosSelecionados,
            style: TextStyle(
              fontSize: screenSize.width * 0.03, 
            ),
          ),
        ],
      ),
    ),
  );
}
}
