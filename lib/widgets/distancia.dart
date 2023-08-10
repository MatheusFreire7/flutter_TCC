import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:background_fetch/background_fetch.dart';

class DistanceTracker extends StatefulWidget {
  @override
  _DistanceTrackerState createState() => _DistanceTrackerState();
}

class _DistanceTrackerState extends State<DistanceTracker> {
  Position? _startPosition;
  double _distance = 0.0;
  FlutterLocalNotificationsPlugin? _notificationPlugin;
  late SharedPreferences _preferences;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _startTracking();
    _loadDistance();
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

  Future<void> _startTracking() async {
    final initialLocation = await Geolocator.getCurrentPosition();
    if (!_disposed) {
      setState(() {
        _startPosition = initialLocation;
      });
    }

    Geolocator.getPositionStream().listen((Position currentPosition) {
      if (!_disposed) {
        updateDistance(currentPosition.latitude, currentPosition.longitude);
        _saveDistance(); // Salvar a distância a cada atualização
      }
    });

// Configurar o serviço em segundo plano para atualizar a distância
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    BackgroundFetch.start().then((status) {
      if (!_disposed) {
        print('[BackgroundFetch] Status: $status');
      }
    }).catchError((e) {
      if (!_disposed) {
        print('[BackgroundFetch] Error: $e');
      }
    });
  }

  void updateDistance(double latitude, double longitude) {
    if (_disposed || _startPosition == null) {
      return;
    }

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
      _startPosition = currentPosition;
    });

// Atualizar a distância percorrida no dia e na semana
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek =
        DateTime(now.year, now.month, now.day - now.weekday + 1);

    if (currentPosition.timestamp!.isAfter(today)) {
      _preferences.setDouble(
          'distance_today', _getDistanceToday() + distanceInMeters);
    }

    if (currentPosition.timestamp!.isAfter(startOfWeek)) {
      _preferences.setDouble(
          'distance_this_week', _getDistanceThisWeek() + distanceInMeters);
    }
  }

  void _saveDistance() {
    _preferences.setDouble('distance', _distance);
  }

  Future<void> _loadDistance() async {
    _preferences = await SharedPreferences.getInstance();
    final distance = _preferences.getDouble('distance') ?? 0.0;
    if (!_disposed) {
      setState(() {
        _distance = distance;
      });
    }
  }

// Tarefa em segundo plano
  void backgroundFetchHeadlessTask(String taskId) async {
    print('[BackgroundFetch] Headless task started: $taskId');
    await _loadDistance();
    if (!_disposed) {
      BackgroundFetch.finish(taskId);
    }
  }

  void _sendNotification() {
    final formattedDistance = (_distance / 1000).toStringAsFixed(2);
    _showNotification('$formattedDistance km percorridos');
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
    BackgroundFetch.stop().then((status) {
      print('[BackgroundFetch] Status: $status');
    });
  }

  double _getDistanceToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final distanceToday = _preferences.getDouble('distance_today') ?? 0.0;
    return distanceToday;
  }

  double _getDistanceThisWeek() {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 1);
    final distanceThisWeek =_preferences.getDouble('distance_this_week') ?? 0.0;
    return distanceThisWeek;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador de Distância Percorrida'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Distância percorrida:',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              '${(_distance / 1000).toStringAsFixed(2)} km',
              style:
                  const TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _sendNotification,
              child: const Text('Enviar Notificação'),
            ),
            const SizedBox(height: 20.0),
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
