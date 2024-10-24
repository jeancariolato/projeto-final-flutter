import 'package:projeto_final/databaseHelper.dart';
import 'agendamento.dart';
import 'package:sqflite/sqflite.dart';

class agendamentoDAO{
  final DatabaseHelper _dbHelper = DatabaseHelper();

  //FUNCOES NO BANCO DE DADOS - AGENDAMENTOS
  Future<int> inserirAgendamento(Map<String, dynamic> agendamento) async {
    final db = await _dbHelper.database;
    return await db.insert('agendamentos', agendamento);
  }

  Future<List<Map<String, dynamic>>> listarAgendamentos() async {
    final db = await _dbHelper.database;
    return await db.query('agendamentos', orderBy: 'data ASC, horariosSelecionados ASC');
  }

  Future<int> deletarAgendamento(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('agendamentos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deletarTodosAgendamentos() async {
    final db = await _dbHelper.database;
    await db.delete('agendamentos');
  }

  // LISTAR HORARIOS OCUPADOS
 Future<List<String>> listarHorariosOcupados(String data) async {
  final db = await _dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query(
    'agendamentos',
    where: 'data = ?',
    whereArgs: [data],
  );

   return maps.map((map) => map['horariosSelecionados'] as String).expand((horarios) => horarios.split(', ')).toList();
 }
}