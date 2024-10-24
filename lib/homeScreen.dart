import 'package:flutter/material.dart';
import 'package:projeto_final/noticiasScreen.dart';
import 'addAgendamentoScreen.dart'; // Tela de agendamento
import 'listaAgendamentosScreen.dart'; // Tela de lista de agendamentos

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Para controlar o item selecionado no BottomNavigationBar

  // As duas telas que vamos alternar
  final List<Widget> _telas = [
    const AddAgendamentoScreen(),  // Tela de Agendamento Manual
    const ListaAgendamentosScreen(),
    NoticiasScreen()  // Tela de Lista de Agendamentos
  ];

  // Método que troca a tela quando um item do BottomNavigationBar é selecionado
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_currentIndex], // Exibe a tela conforme o índice selecionado
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Índice atual selecionado
        onTap: _onTabTapped, // Método chamado quando um item é selecionado
        selectedItemColor: Colors.orange, // Cor do item selecionado
        unselectedItemColor: Colors.grey, // Cor dos itens não selecionados
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 30,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 30,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper, size: 30,),
            label: '',
          ),
        ],
      ),
    );
  }
}
