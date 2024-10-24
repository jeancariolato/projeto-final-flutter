import 'package:flutter/material.dart';
import 'package:projeto_final/agendamentoDAO.dart';
// Certifique-se que você importou a classe do banco
import 'AgendamentoCard.dart';

class ListaAgendamentosScreen extends StatefulWidget {
  const ListaAgendamentosScreen({super.key});

  @override
  _ListaAgendamentosScreenState createState() =>
      _ListaAgendamentosScreenState();
}

class _ListaAgendamentosScreenState extends State<ListaAgendamentosScreen> {
  //Instanciando objeto DAO do agendamento
  final agendamentoDAO _agendamentoDAO = agendamentoDAO();

  List<Map<String, dynamic>> agendamentos = [];

  @override
  void initState() {
    super.initState();
    _carregarAgendamentos();
  }
//Função carregar agendamentos
  Future<void> _carregarAgendamentos() async {
    List<Map<String, dynamic>> agendamentosCarregados =
        await _agendamentoDAO.listarAgendamentos();
    setState(() {
      agendamentos = agendamentosCarregados;
    });
  }
//função para deletar
  Future<void> _deletarAgendamento(int id) async {
    //Chama função no banco
    await _agendamentoDAO.deletarAgendamento(id); 
    // Recarrega a lista de agendamentos
    _carregarAgendamentos(); 
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Agendamento deletado com sucesso.'),
    ));
  }

//função para deletar todos os agendamentos
  Future<void> _deletarTodosAgendamentos() async {
    await _agendamentoDAO.deletarTodosAgendamentos(); // Chama sua função para deletar todos os agendamentos
    _carregarAgendamentos(); // Recarrega a lista de agendamentos
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Todos os agendamentos foram deletados.'),
    ));
  }

//ALERTA DE CONFIRMAÇÃO PARA EXCLUSÃO TOTAL DE AGENDAMENTOS
//utilizando Widget showDialog
  void _confirmarDelecao() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar remoção'),
        content:
            const Text('Tem certeza que deseja deletar todos os agendamentos?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _deletarTodosAgendamentos(); 
              Navigator.of(context).pop();
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  // Método para calcular e mostrar o lucro previsto
  void _mostrarLucroPrevisto() async {
    double lucroPrevisto =
        await _calcularLucroPrevisto(); 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity, 
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              const Text(
                'Lucro Previsto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, 
              ),
              const SizedBox(height: 10),
              Text(
                'O lucro previsto é: R\$ ${lucroPrevisto.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center, 
              ),
              const SizedBox(height: 20), 
              
            ],
          ),
        );
      },
    );
  }

  // Método para calcular o lucro previsto com base nos agendamentos
  Future<double> _calcularLucroPrevisto() async {
    double lucroTotal = 0.0;
    for (var agendamento in agendamentos) {
      lucroTotal += agendamento['valorTotal'];
    }
    return lucroTotal;
  }

  @override
Widget build(BuildContext context) {
  //Variavel que obtem tela total do dispostivo
  final screenSize = MediaQuery.of(context).size; 

  return Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Lista de Agendamentos',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _mostrarLucroPrevisto,
                icon: const Icon(
                  Icons.attach_money,
                  color: Colors.orange,
                ),
              ),
              IconButton(
                onPressed: _confirmarDelecao,
                icon: const Icon(
                  Icons.restore,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    body: Padding(
      padding: EdgeInsets.all(screenSize.width * 0.04), 
      child: agendamentos.isEmpty
          ? Center(
              child: Text(
                'Nenhum agendamento disponível.',
                style: TextStyle(fontSize: screenSize.width * 0.05),
              ),
            )
          : ListView.builder(
              itemCount: agendamentos.length,
              itemBuilder: (context, index) {
                final agendamento = agendamentos[index];
                return Dismissible(
                  key: Key(agendamento['id'].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.orange,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05), 
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    _deletarAgendamento(agendamento['id']);
                  },
                  child: AgendamentoCard(
                    nomeResponsavel: agendamento['nomeResponsavel'],
                    data: agendamento['data'],
                    horariosSelecionados: agendamento['horariosSelecionados'],
                    valorTotal: agendamento['valorTotal'],
                  ),
                );
              },
            ),
    ),
  );
}
}
