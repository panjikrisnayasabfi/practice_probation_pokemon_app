import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:practice_probation_pokemon_app/push_notification_service.dart';

import 'app_constants.dart';
import 'core/config/flavor_config.dart';
import 'firebase_options.dart';
import 'main.dart';

void main() async {
  // initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final pushNotificationService = PushNotificationService(_firebaseMessaging);
  pushNotificationService.initialize();

  FlavorConfig(
      appTitle: appTitleDev,
      appBarColor: Colors.red,
      flavor: Flavor.DEV,
      values: FlavorValues(
          baseUrl: 'https://pokeapi.co/api/v2/',
          passwordConfig: '',
          usernameConfig: ''));
  runApp(MyApp());
}
