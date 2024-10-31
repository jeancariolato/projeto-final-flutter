import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:projeto_final/agendamentoDAO.dart';
import 'package:intl/date_symbol_data_local.dart';

class AddAgendamentoScreen extends StatefulWidget {
  const AddAgendamentoScreen({super.key});

  @override
  _AddAgendamentoScreenState createState() => _AddAgendamentoScreenState();
}

class _AddAgendamentoScreenState extends State<AddAgendamentoScreen> {
  final agendamentoDAO _agendamentoDAO = agendamentoDAO();

  final TextEditingController _nomeController = TextEditingController();
  DateTime? _selectedDate; // Armazena a data selecionada no calendário

  List<String> sports = ['Futebol', 'Volei', 'Basquete'];
  int? selectedChipIndex; // Alterado para armazenar apenas o índice do chip selecionado

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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  Future<void> _carregarHorariosOcupados(DateTime date) async {
    final dataFormatada =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    List<String> horariosOcupados =
        await _agendamentoDAO.listarHorariosOcupados(dataFormatada);

    setState(() {
      horariosDisponiveis = [
        '17:00',
        '18:00',
        '19:00',
        '20:00',
        '21:00',
        '22:00',
        '23:00'
      ].where((horario) => !horariosOcupados.contains(horario)).toList();
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
    if (_selectedDate == null) return false;
    final dataFormatada =
        '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}';
    List<String> horariosOcupados =
        await _agendamentoDAO.listarHorariosOcupados(dataFormatada);
    return horarioSelecionado != null &&
        horariosOcupados.contains(horarioSelecionado!);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento Manual'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.03),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration:
                  const InputDecoration(labelText: 'Nome do Responsável'),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(sports.length, (index) {
                return Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.01),
                  child: ChoiceChip(
                    label: Row(children: [
                      Icon(
                        index == 0
                            ? Icons.sports_soccer
                            : index == 1
                                ? Icons.sports_volleyball
                                : Icons.sports_basketball,
                        color: selectedChipIndex == index
                            ? Colors.white
                            : const Color.fromARGB(255, 139, 139, 139),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sports[index],
                        style: TextStyle(
                            color: selectedChipIndex == index
                                ? Colors.white
                                : const Color.fromARGB(255, 153, 153, 153)),
                      )
                    ]),
                    selected: selectedChipIndex == index,
                    showCheckmark: false,
                    selectedColor: Colors.orange,
                    backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                    onSelected: (bool value) {
                      setState(() {
                        selectedChipIndex = value ? index : null; // Armazena o índice do chip selecionado
                      });
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: screenSize.height * 0.01),
            SizedBox(
              width: screenSize.width * 0.9,
              height: screenSize.height * 0.45,
              child: TableCalendar(
                calendarStyle: const CalendarStyle(
                  cellMargin: EdgeInsets.all(1),
                  weekendTextStyle:
                      TextStyle(fontSize: 14, color: Colors.black),
                  defaultTextStyle:
                      TextStyle(fontSize: 14, color: Colors.black),
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: Colors.orange, // Cor do fundo da data selecionada
                    shape: BoxShape.circle, // Forma do círculo
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 187, 90, 12), // Cor do fundo do dia atual
                    shape: BoxShape.circle, // Forma do círculo
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle:
                      TextStyle(fontSize: 12), // Tamanho dos dias da semana
                  weekendStyle: TextStyle(fontSize: 12),
                ),
                headerStyle: const HeaderStyle(
                  titleTextStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  formatButtonVisible: false,
                  titleCentered:
                      true, // Remove o botão de formato, se necessário
                ),
                calendarFormat: CalendarFormat.month,
                locale: 'pt_BR',
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _selectedDate ?? DateTime.now(),
                selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _carregarHorariosOcupados(selectedDay);
                  });
                },
              ),
            ),
            SizedBox(height: screenSize.height * 0.005),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: horariosDisponiveis.map((horario) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.02),
                    child: ChoiceChip(
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
                    ),
                  );
                }).toList(),
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
                    'data':
                        '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
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
                  _selectedDate = null;
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
            SizedBox(height: screenSize.height * 0.02),
          ],
        ),
      ),
    );
  }
}
