import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:practice_probation_pokemon_app/core/resources/colors.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging;

  PushNotificationService(
    firebaseMessaging,
  ) : _firebaseMessaging = firebaseMessaging;

  Future initialize() async {
    final callChannel = NotificationChannel(
      channelKey: 'call_channel',
      channelName: 'Call Channel',
      channelDescription: 'Notification channel to receive a call',
      channelShowBadge: true,
      importance: NotificationImportance.Max,
      playSound: true,
      defaultRingtoneType: DefaultRingtoneType.Ringtone,
      enableVibration: true,
      enableLights: false,
      criticalAlerts: true,
      locked: true,
      onlyAlertOnce: false,
      defaultPrivacy: NotificationPrivacy.Public,
    );

    final notificationChannel = NotificationChannel(
      channelKey: 'notification_channel',
      channelName: 'Notification Channel',
      channelDescription: 'Notification channel',
      channelShowBadge: true,
      importance: NotificationImportance.High,
      playSound: true,
      defaultRingtoneType: DefaultRingtoneType.Notification,
      enableVibration: true,
      enableLights: true,
      criticalAlerts: false,
      locked: false,
      onlyAlertOnce: true,
    );

    AwesomeNotifications().initialize(
      null,
      [
        callChannel,
        notificationChannel,
      ],
      debug: true,
    );

    // listen to messages whilst the app is in the background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // On iOS, this helps to take the user permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // subscribe to topic on each app start-up
      await _firebaseMessaging.subscribeToTopic('pokemon');

      // listen to opened messages
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Message clicked!');
      });

      // listen to messages whilst the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        RemoteNotification notification = message.notification;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null) {
          if (message.data['type'] == 'call') {
            _createCallNotification(notification);
          }
          if (message.data['type'] == 'notification') {
            _createNotification(notification);
          }
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");

  if (message.data['type'] == 'call') {
    _createCallNotification(message.notification);
  }
  if (message.data['type'] == 'notification') {
    _createNotification(message.notification);
  }
}

void _createCallNotification(RemoteNotification notification) async {
  // TODO: notification sound is not repeating when app in the background or terminated
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 0,
      channelKey: 'call_channel',
      title: notification.title,
      body: notification.body,
      summary: 'Call Notification',
      wakeUpScreen: true,
      locked: true,
      autoDismissible: false,
      category: NotificationCategory.Call,
      fullScreenIntent: true, // lock the notification
      notificationLayout: NotificationLayout.Messaging,
      displayOnBackground: true,
      displayOnForeground: true,
      criticalAlert: true,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'reject',
        label: 'Reject',
        color: ColorName.red,
        icon: 'resource://drawable/res_reject', // TODO: unable to show the icon
      ),
      NotificationActionButton(
        key: 'pickup',
        label: 'Pickup',
        color: ColorName.green,
        icon: 'resource://drawable/res_pickup', // TODO: unable to show the icon
      ),
    ],
  );
}

void _createNotification(RemoteNotification notification) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'notification_channel',
      title: notification.title,
      body: notification.body,
      summary: 'Notification',
      wakeUpScreen: true,
      locked: false,
      autoDismissible: true,
      category: NotificationCategory.Reminder,
      fullScreenIntent: false, // lock the notification
      notificationLayout: NotificationLayout.Default,
      displayOnBackground: true,
      displayOnForeground: true,
    ),
  );
}
