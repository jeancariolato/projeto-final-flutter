import 'package:flutter/material.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receber'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Escaneie o código e faça o pagamento via pix"),
              const SizedBox(height: 20),
              // Adicionando a imagem do QR Code
              SizedBox(
                height: screenSize.height * 0.35,
                width: screenSize.width * 0.7,
                
                child: Image.asset(
                  'lib/assets/qr_code.png', // Caminho para a imagem
                  height: screenSize.height *
                      0.3, // Altura da imagem, ajuste conforme necessário
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: screenSize.width * 0.75,
                height: screenSize.height * 0.07,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 219, 166),
                  borderRadius:
                      BorderRadius.circular(15.0), // Borda arredondada
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centraliza o conteúdo na horizontal
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Centraliza o conteúdo na vertical
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Color.fromARGB(255, 255, 153, 0),
                    ),
                    Text(
                      "quadraesportes@gmail.com",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Informações de Pagamento',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Pagamento: R\$120,00\nVencimento: 30/12/2023",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
