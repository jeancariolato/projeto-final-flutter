import 'package:flutter/material.dart';
import 'package:projeto_final/agendamentoDAO.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class AddAgendamentoScreen extends StatefulWidget {
  const AddAgendamentoScreen({super.key});

  @override
  _AddAgendamentoScreenState createState() => _AddAgendamentoScreenState();
}

class _AddAgendamentoScreenState extends State<AddAgendamentoScreen> {
  final agendamentoDAO _agendamentoDAO = agendamentoDAO();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

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
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  Future<void> _carregarHorariosOcupados(String data) async {
    List<String> horariosOcupados =
        await _agendamentoDAO.listarHorariosOcupados(data);

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

      horariosDisponiveis = horariosDisponiveis
          .where((horario) => !horariosOcupados.contains(horario))
          .toList();
      horarioSelecionado = null;
      valorTotal = 0.0;
    });
  }

  void _calcularValorTotal() {
    setState(() {
      valorTotal = (horarioSelecionado != null) ? 120 : 0;
    });
  }

  Future<bool> _verificarAgendamentosOcupados() async {
    List<String> horariosOcupados =
        await _agendamentoDAO.listarHorariosOcupados(_dataController.text);
    return horarioSelecionado != null &&
        horariosOcupados.contains(horarioSelecionado!);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDate = day;
      _dataController.text =
          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";
      _carregarHorariosOcupados(_dataController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento Manual'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 214, 214, 214),
                  size: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Responsável',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 219, 219, 219)),
                      ),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.02),
            TableCalendar(
              locale: 'pt_BR',
              focusedDay: selectedDate,
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
              onDaySelected: _onDaySelected,
              headerStyle: const HeaderStyle(
                titleTextStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 192, 86, 0),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
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
                      horarioSelecionado = selected ? horario : null;
                      _calcularValorTotal();
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: screenSize.height * 0.02),
            ElevatedButton(
              onPressed: () async {
                if (_nomeController.text.isEmpty ||
                    _dataController.text.isEmpty ||
                    horarioSelecionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Preencha o nome, selecione uma data e um horário.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }

                bool ocupados = await _verificarAgendamentosOcupados();

                if (ocupados) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Horário ou data já ocupados. Escolha outra opção.'),
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
                  borderRadius: BorderRadius.circular(10),
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
