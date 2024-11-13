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
  // Instância do Dio
  Dio dio = Dio(); 

  @override
  void initState() {
    super.initState();
    _carregarNoticias();
  }

  // Função para carregar o JSON da API usando Dio
  Future<void> _carregarNoticias() async {
    try {
      //Link do json das noticias de esporte do jornal A plateia
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
    return DateFormat('dd-MM-yyyy').format(parsedDate); 
  }

  @override
  Widget build(BuildContext context) {
    //Obtendo tamanho total da tela
    final screenSize = MediaQuery.of(context).size; 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notícias do Esporte',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.05, 
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: noticias.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: noticias.length,
                itemBuilder: (context, index) {
                  //CARREGANDO OS ITENS DO JSON DO SITE DO JORNAL
                  final noticia = noticias[index];
                  final titulo = noticia['title']['rendered'];
                  final dataOriginal = noticia['date'];
                  // Formatando a data
                  final dataFormatada = formatarData(dataOriginal); 
                  final link = noticia['link'];
                  final content = limparConteudo(noticia['content']['rendered']);

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

  // Função para limpar o conteúdo HTML
  String limparConteudo(String conteudo) {
  final regex = RegExp(r'<[^>]*>');
  return conteudo.replaceAll(regex, ''); // Substitui as tags por uma string vazia
}
}
