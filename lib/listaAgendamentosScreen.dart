import 'package:flutter/material.dart';
import 'package:projeto_final/agendamentoDAO.dart';
import 'AgendamentoCard.dart';
import 'QRCodeScreen.dart';

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
    await _agendamentoDAO.deletarAgendamento(id);
    _carregarAgendamentos();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Agendamento deletado com sucesso.'),
    ));
  }

  Future<void> _deletarTodosAgendamentos() async {
    await _agendamentoDAO.deletarTodosAgendamentos();
    _carregarAgendamentos();
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

  Future<double> _calcularLucroPrevisto() async {
    double lucroTotal = 0.0;
    for (var agendamento in agendamentos) {
      lucroTotal += agendamento['valorTotal'];
    }
    return lucroTotal;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRCodeScreen()),
                );
              },
              icon: const Icon(
                Icons.qr_code,
                color: Colors.orange,
              ),
            ),
            Row(
              children: [
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<double>(
              future: _calcularLucroPrevisto(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Erro ao carregar lucro previsto');
                } else {
                  double lucroPrevisto = snapshot.data ?? 0.0;
                  return SizedBox(
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          // Centralizando a Row
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Para que a Row ocupe o menor espaço necessário
                            children: [
                              Icon(Icons.trending_up),
                              SizedBox(
                                  width: 8), // Espaço entre o ícone e o texto
                              Text(
                                'Lucro Previsto',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 129, 129, 129),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'R\$${lucroPrevisto.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16), // Espaço entre lucro e título da lista

            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.event,
                    color: Color.fromARGB(255, 136, 136, 136),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Lista de Agendamentos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 136, 136, 136),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 12), // Espaço entre título e lista de agendamentos

            Expanded(
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
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.05),
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
                            horariosSelecionados:
                                agendamento['horariosSelecionados'],
                            valorTotal: agendamento['valorTotal'],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
