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
  int _currentIndex = 0; // Index para controlar posição na BottomNavigation

  // As telas que vão estar disponiveis
  final List<Widget> _telas = [
    const AddAgendamentoScreen(),  
    const ListaAgendamentosScreen(),
    const NoticiasScreen()
  ];

  // Método que troca a tela quando item da BottomNavigation é selecionado
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, 
        onTap: _onTabTapped, 
        selectedItemColor: Colors.orange, 
        unselectedItemColor: Colors.grey, 
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
