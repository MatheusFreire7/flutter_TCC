import 'package:flutter/material.dart';

class TelaTreino extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const TelaTreino({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.network(imageUrl),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 50,
          ),
        ),
      ),
    );
  }
}
