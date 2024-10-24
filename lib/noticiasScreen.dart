import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:projeto_final/NoticiaCard.dart'; // Importa o pacote intl

class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  _NoticiasScreenState createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  List<dynamic> noticias = [];
  Dio dio = Dio(); // Instância do Dio

  @override
  void initState() {
    super.initState();
    _carregarNoticias();
  }

  // Função para carregar o JSON da API usando Dio
  Future<void> _carregarNoticias() async {
    try {
      final response = await dio
          .get('https://www.aplateia.com.br/wp-json/wp/v2/posts?categories=6');

      if (response.statusCode == 200) {
        setState(() {
          noticias = response.data;
        });
      } else {
        throw Exception('Erro ao carregar as notícias');
      }
    } catch (e) {
      print('Erro: $e');
      throw Exception('Erro ao carregar as notícias');
    }
  }

  // Função para formatar a data
  String formatarData(String data) {
    DateTime parsedDate =
        DateTime.parse(data); // Converte a string para DateTime
    return DateFormat('dd-MM-yyyy').format(parsedDate); // Formata a data
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Obtendo o tamanho da tela

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notícias do Esporte',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.05, // Ajuste proporcional
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04), // Ajuste proporcional
        child: noticias.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: noticias.length,
                itemBuilder: (context, index) {
                  final noticia = noticias[index];
                  final titulo = noticia['title']['rendered'];
                  final dataOriginal = noticia['date'];
                  final dataFormatada =
                      formatarData(dataOriginal); // Formata a data
                  final link = noticia['link'];
                  final content = noticia['content']['rendered'];

                  return NoticiaCard(
                    titulo: titulo,
                    dataFormatada: dataFormatada,
                    link: link,
                    conteudo: content,
                  );
                },
              ),
      ),
    );
  }
}
