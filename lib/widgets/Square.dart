import 'package:flutter/material.dart';

class MySquare extends StatelessWidget {
  final String child;
  final int intensidade;

  const MySquare({
    required this.child,
    required this.intensidade,
  });

  String? convertIntensidade(int intensidade) {
    if (intensidade == 1) {
      return "Intensidade: Baixa";
    }

    if (intensidade == 2) {
      return "Intensidade: Intermediária";
    }

    if (intensidade == 3) {
      return "Intensidade: Alta";
    }

    return null; // Retorna null quando não houver intensidade
  }

  String? getImageUrl(String child) {
    switch (child) {
      case "Super ganho de massa muscular":
        return "https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2023/08/08/92887309-musculacao.jpg";
      case "Treino para definir":
        return "https://saude.abril.com.br/wp-content/uploads/2023/08/homem-academia-musculacao-fitness.jpg?quality=85&strip=info&w=1024";
      case "Treino para resistência":
        return "https://treinamentosurfevolutivo.com.br/wp-content/uploads/2018/04/Capacidade-1024x683.jpg";
      case "Perda de peso":
        return "https://emc.acidadeon.com/dbimagens/corrida_de_1200x675_31052022090353.webp";
      case "Treino para manter o peso":
        return "https://gooutside.com.br/wp-content/uploads/sites/3/2022/04/shutterstock_493940722-696x464.jpg";
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? intensidadeText = convertIntensidade(intensidade);
    String? imageUrl = getImageUrl(child);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        width: 350,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (imageUrl != null)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return const Placeholder(
                    color: Colors.grey,
                    fallbackWidth: 250,
                    fallbackHeight: 200,
                  );
                },
              ),
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        child,
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      if (intensidadeText != null)
                        Text(
                          intensidadeText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
