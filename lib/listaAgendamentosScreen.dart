import 'package:flutter/material.dart';
import 'package:projeto_final/agendamentoDAO.dart';
import 'databaseHelper.dart'; // Certifique-se que você importou a classe do banco
import 'AgendamentoCard.dart';

class ListaAgendamentosScreen extends StatefulWidget {
  const ListaAgendamentosScreen({super.key});

  @override
  _ListaAgendamentosScreenState createState() =>
      _ListaAgendamentosScreenState();
}

class _ListaAgendamentosScreenState extends State<ListaAgendamentosScreen> {
  final agendamentoDAO _agendamentoDAO = agendamentoDAO();

  List<Map<String, dynamic>> agendamentos = [];

  @override
  void initState() {
    super.initState();
    _carregarAgendamentos();
  }

  Future<void> _carregarAgendamentos() async {
    List<Map<String, dynamic>> agendamentosCarregados =
        await _agendamentoDAO.listarAgendamentos();
    setState(() {
      agendamentos = agendamentosCarregados;
    });
  }

  Future<void> _deletarAgendamento(int id) async {
    await _agendamentoDAO.deletarAgendamento(id); // Chama a função para deletar um agendamento específico
    _carregarAgendamentos(); // Recarrega a lista de agendamentos
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Agendamento deletado com sucesso.'),
    ));
  }

  Future<void> _deletarTodosAgendamentos() async {
    await _agendamentoDAO.deletarTodosAgendamentos(); // Chama sua função para deletar todos os agendamentos
    _carregarAgendamentos(); // Recarrega a lista de agendamentos
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Todos os agendamentos foram deletados.'),
    ));
  }

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
              Navigator.of(context).pop(); // Fecha o diálogo
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _deletarTodosAgendamentos(); // Deleta todos os agendamentos
              Navigator.of(context).pop(); // Fecha o diálogo
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
        await _calcularLucroPrevisto(); // Chama o método para calcular lucro

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity, // Garante que o modal ocupe toda a largura
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Para que a altura do modal se ajuste ao conteúdo
            children: [
              const Text(
                'Lucro Previsto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Centraliza o texto
              ),
              const SizedBox(height: 10),
              Text(
                'O lucro previsto é: R\$ ${lucroPrevisto.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center, // Centraliza o texto
              ),
              const SizedBox(height: 20), // Espaço entre o texto e o botão
              
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
      lucroTotal +=
          agendamento['valorTotal']; // Supondo que valorTotal armazena o lucro
    }
    return lucroTotal;
  }

  @override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size; // Obtendo o tamanho da tela

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
      padding: EdgeInsets.all(screenSize.width * 0.04), // Ajuste proporcional
      child: agendamentos.isEmpty
          ? Center(
              child: Text(
                'Nenhum agendamento disponível.',
                style: TextStyle(fontSize: screenSize.width * 0.05), // Ajuste proporcional
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
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05), // Ajuste proporcional
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
