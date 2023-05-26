import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DistanceTracker extends StatefulWidget {
  @override
  _DistanceTrackerState createState() => _DistanceTrackerState();
}

class _DistanceTrackerState extends State<DistanceTracker> {
  Position? _startPosition;
  double _distance = 0.0;
  FlutterLocalNotificationsPlugin? _notificationPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _startTracking();
  }

  Future<void> _initializeNotifications() async {
    _notificationPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationPlugin!.initialize(initializationSettings);
  }

  Future<void> _showNotification(String content) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'distance_channel',
      'Distance Tracker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationPlugin!.show(
      0,
      'Distance Tracker',
      content,
      platformChannelSpecifics,
    );
  }

  void updateDistance(double latitude, double longitude) {
    if (_startPosition != null) {
      final currentPosition = Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

      final distanceInMeters = Geolocator.distanceBetween(
        _startPosition!.latitude,
        _startPosition!.longitude,
        currentPosition.latitude,
        currentPosition.longitude,
      );

      setState(() {
        _distance += distanceInMeters;
       // _startPosition = currentPosition;
      });
    }
  }

  Future<void> _startTracking() async {
    final initialLocation = await Geolocator.getCurrentPosition();
    setState(() {
      _startPosition = initialLocation;
    });

    Geolocator.getPositionStream().listen((Position currentPosition) {
      updateDistance(currentPosition.latitude, currentPosition.longitude);
    });
  }

  void _sendNotification() {
    final formattedDistance = (_distance / 1000).toStringAsFixed(2);
    _showNotification('$formattedDistance km percorridos');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador de Distância Percorrida'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Distância percorrida:',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              '${(_distance / 1000).toStringAsFixed(2)} km',
              style: const TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _sendNotification,
              child: const Text('Enviar Notificação'),
            ),
            ElevatedButton(
              onPressed: () {
                // Simular a alteração da localização manualmente
                // Atualize as coordenadas abaixo para simular diferentes localizações
                updateDistance(-22.9007665, -47.0688856);
              },
              child: const Text('Atualizar Localização'),
            ),
          ],
        ),
      ),
    );
  }


}

void main() {
  runApp(MaterialApp(
    title: 'Distance Tracker',
    home: DistanceTracker(),
  ));
}
