import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../settings/theme.dart';

class Progresso extends StatelessWidget {
  final List<charts.Series<ProgressoData, String>> seriesList;
  final bool animate;

  Progresso(this.seriesList, {required this.animate});

  factory Progresso.withSampleData() {
    return Progresso(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppTheme.iconColor), // Define a cor do ícone na app bar
            backgroundColor: AppTheme.appBarColor,
            //title: const Text('Progresso'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Seu Progresso',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: charts.BarChart(
                seriesList,
                animate: animate,
                vertical: false,
                barRendererDecorator: charts.BarLabelDecorator<String>(
                  labelPosition: charts.BarLabelPosition.auto,
                  insideLabelStyleSpec: const  charts.TextStyleSpec(
                    color: charts.MaterialPalette.white,
                    fontSize: 12,
                  ),
                  outsideLabelStyleSpec: const charts.TextStyleSpec(
                    color: charts.MaterialPalette.black,
                    fontSize: 12,
                  ),
                ),
                domainAxis:const charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.black,
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryMeasureAxis:const  charts.NumericAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    lineStyle: charts.LineStyleSpec(
                      thickness: 0,
                    ),
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class ProgressoData {
  final String goal;
  final int progress;

  ProgressoData(this.goal, this.progress);
}

//Dados Teste
List<charts.Series<ProgressoData, String>> _createSampleData() {
  final data = [
    ProgressoData('Perda de Peso', 10),
    ProgressoData('Ganho de Massa Muscular', 7),
    ProgressoData('Treinos Diários Realizados', 70),
  ];

  return [
    charts.Series<ProgressoData, String>(
      id: 'Progresso',
      domainFn: (ProgressoData progresso, _) => progresso.goal,
      measureFn: (ProgressoData progresso, _) => progresso.progress,
      data: data,
      labelAccessorFn: (ProgressoData progresso, _) => '${progresso.progress}%',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
    ),
  ];
}
