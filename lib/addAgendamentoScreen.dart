import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_final/agendamentoDAO.dart';
import 'databaseHelper.dart';
import 'package:projeto_final/agendamentoDAO.dart';

class AddAgendamentoScreen extends StatefulWidget {
  const AddAgendamentoScreen({super.key});

  @override
  _AddAgendamentoScreenState createState() => _AddAgendamentoScreenState();
}

class _AddAgendamentoScreenState extends State<AddAgendamentoScreen> {
  //Instanciando objeto do DAO
  final agendamentoDAO _agendamentoDAO = agendamentoDAO();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

//WIDGET PARA MASCARA  DA DATA
  final MaskTextInputFormatter _dataFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

//Lista de Horários disponiveis no aplicativo
  List<String> horariosDisponiveis = [
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
    '23:00'
  ];

  String? horarioSelecionado;
  double valorTotal = 0.0;

//Inicializador
  @override
  void initState() {
    super.initState();
  }

//METODO PARA CARREGAR HORÁRIOS OCUPADOS
  Future<void> _carregarHorariosOcupados(String data) async {
    List<String> horariosOcupados =
        await _agendamentoDAO.listarHorariosOcupados(data);

    setState(() {
      // Reinicia a lista de horários disponíveis toda vez que a data muda...
      horariosDisponiveis = [
        '17:00',
        '18:00',
        '19:00',
        '20:00',
        '21:00',
        '22:00',
        '23:00'
      ];

      // Filtragem dos horários ocupados
      horariosDisponiveis = horariosDisponiveis
          .where((horario) => !horariosOcupados.contains(horario))
          .toList();
      horarioSelecionado = null; // Limpa o horário selecionado
      valorTotal = 0.0; // Reinicia valor total
    });
  }

//METODO PARA CALCULAR VALOR TOTAL DE ACORDO COM A QUANTIDADE DE AGENDAMENTOS
//PREÇO FIXO POR ALUGUEL DE R$120
  void _calcularValorTotal() {
    setState(() {
      valorTotal = (horarioSelecionado != null) ? 120 : 0;
    });
  }

//Listagem de Horários ocupados
  Future<bool> _verificarAgendamentosOcupados() async {
    List<String> horariosOcupados =
        await _agendamentoDAO.listarHorariosOcupados(_dataController.text);
    return horarioSelecionado != null &&
        horariosOcupados.contains(horarioSelecionado!);
  }

  @override
  Widget build(BuildContext context) {
    //Variavel representa tela total do app para possibilitar ajustes de responsividade
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento Manual'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04), 
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration:
                  const InputDecoration(labelText: 'Nome do Responsável'),
            ),
            SizedBox(height: screenSize.height * 0.02), 
            TextField(
              controller: _dataController,
              decoration:
                  const InputDecoration(labelText: 'Data (Dia/Mês/Ano)'),
              inputFormatters: [_dataFormatter],
              onChanged: (value) {
                if (value.length == 10) {
                  _carregarHorariosOcupados(value);
                } else {
                  // Resetar horários se a data não estiver completa
                  setState(() {
                    horariosDisponiveis = [
                      '17:00',
                      '18:00',
                      '19:00',
                      '20:00',
                      '21:00',
                      '22:00',
                      '23:00'
                    ];
                    horarioSelecionado = null; 
                    valorTotal = 0.0; 
                  });
                }
              },
            ),
            SizedBox(height: screenSize.height * 0.02), 
            Wrap(
              spacing: screenSize.width * 0.02, 
              children: horariosDisponiveis.map((horario) {
                return ChoiceChip(
                  label: Text(horario),
                  selected: horarioSelecionado == horario,
                  selectedColor: Colors.orange,
                  backgroundColor: Colors.grey[200],
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        horarioSelecionado = horario;
                      } else {
                        horarioSelecionado = null;
                      }
                      _calcularValorTotal();
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: screenSize.height * 0.02), 
            Text(
              'Valor Total: R\$${valorTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: screenSize.width * 0.05, 
                color: const Color.fromARGB(255, 105, 105, 105),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02), 
            ElevatedButton(
              onPressed: () async {
                bool ocupados = await _verificarAgendamentosOcupados();

                if (ocupados) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Horário ou data já ocupados. Escolha outra opção.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  await _agendamentoDAO.inserirAgendamento({
                    'nomeResponsavel': _nomeController.text,
                    'data': _dataController.text,
                    'horariosSelecionados': horarioSelecionado ?? '',
                    'valorTotal': valorTotal,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Agendamento registrado com sucesso!'),
                      duration: Duration(seconds: 3),
                    ),
                  );

                  // Limpar campos após salvar
                  _nomeController.clear();
                  _dataController.clear();
                  horarioSelecionado = null;
                  horariosDisponiveis = [
                    '17:00',
                    '18:00',
                    '19:00',
                    '20:00',
                    '21:00',
                    '22:00',
                    '23:00'
                  ];
                  valorTotal = 0.0;
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    Size(screenSize.width * 0.8, screenSize.height * 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                backgroundColor: const Color.fromARGB(255, 255, 102, 0),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
