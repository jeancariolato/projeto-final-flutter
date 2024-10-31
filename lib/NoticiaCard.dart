import 'package:flutter/material.dart';

class NoticiaCard extends StatelessWidget {
  final String titulo;
  final String dataFormatada;
  final String link;
  final String conteudo;

  const NoticiaCard({
    super.key,
    required this.titulo,
    required this.dataFormatada,
    required this.link,
    required this.conteudo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          // Mostra o conteúdo completo da notícia no BottomSheet que ocupa a tela toda
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Faz o modal ocupar toda a tela
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height * 0.95, // Ocupa quase toda a tela
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context); // Fecha o modal
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Ajuste para quebrar o título em várias linhas se necessário
                        Expanded(
                          child: Text(
                            titulo,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true, // Permite quebra automática
                            overflow: TextOverflow.visible, // Faz o texto aparecer mesmo se for longo
                          ),
                        ),
                        
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      dataFormatada,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          conteudo,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                softWrap: true, // Permite quebra automática no Card também
                overflow: TextOverflow.visible, // Caso o texto seja muito grande
              ),
              const SizedBox(height: 8),
              Text(
                dataFormatada,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
