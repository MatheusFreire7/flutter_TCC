import 'dart:async';
import 'dart:html' as html;
import 'package:flutter_login/settings/theme.dart';

class NotificationWater {
  static NotificationWater? _instance;
  static NotificationWater get instance {
    if (_instance == null) {
      _instance = NotificationWater._();
    }
    return _instance!;
  }

  NotificationWater._();

  DateTime?
      lastNotificationTime; // Armazene a última vez que a notificação foi enviada

  void showWaterReminderNotification() {
    if (!AppTheme.notificationsEnabled) {
      // Verifica se as notificações estão habilitadas no AppTheme
      return;
    }

    final currentTime = DateTime.now();
    if (lastNotificationTime == null ||
        currentTime.difference(lastNotificationTime!) >= Duration(hours: 2)) {
      // Verifica se já se passaram duas horas desde a última notificação
      lastNotificationTime = currentTime;
      print(currentTime);

      if (html.Notification.supported) {
        html.Notification.requestPermission().then((permission) {
          if (permission == 'granted') {
            final notification = html.Notification('Hora de beber água!',
                body: 'Lembre-se de beber um copo de água.');
            notification.onClick.listen((_) {
              // Ação a ser executada quando o usuário clicar na notificação
              // Você pode adicionar uma ação personalizada aqui, se necessário
            });
          } else {
            // Lidar com o caso em que a permissão não é concedida
            print('Permissão para notificações não concedida');
            showErrorNotification('Erro de Permissão',
                'Você não concedeu permissão para notificações.');
          }
        }).catchError((error) {
          // Lidar com erros na solicitação de permissão
          print('Erro na solicitação de permissão: $error');
          showErrorNotification('Erro de Solicitação de Permissão',
              'Houve um erro ao solicitar permissão para notificações.');
        });
      } else {
        // Lidar com o caso em que as notificações não são suportadas
        print('Notificações não são suportadas neste navegador');
        showErrorNotification('Notificações Não Suportadas',
            'Este navegador não suporta notificações.');
      }
    }
  }

  void showErrorNotification(String title, String message) {
    final notification = html.Notification(title, body: message);
    notification.onClick.listen((_) {
      // Ação a ser executada quando o usuário clicar na notificação de erro
      // Você pode adicionar uma ação personalizada aqui, se necessário
    });
  }
}

void main() {
  // Exemplo de uso do serviço de notificação em diferentes partes do aplicativo
  final notificationService = NotificationWater.instance;
  notificationService.showWaterReminderNotification();
}
