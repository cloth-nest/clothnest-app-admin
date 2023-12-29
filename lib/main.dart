import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/app.dart';
import 'package:grocery/data/services/firebase_service.dart';
import 'package:grocery/firebase_options.dart';
import 'package:grocery/presentation/utils/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'ClothNest-admin',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseService().registerNotification();
  FirebaseMessaging.onBackgroundMessage(handleMessageBackground);

  // final message = await FirebaseMessaging.instance.getInitialMessage();
  // FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //   debugPrint('open app: ${message.from}');
  // });

  // if (message != null) {
  //   debugPrint('on click: ${message.from}');
  // }

  Bloc.observer = AppBlocObserver();

  runApp(const App());
}

Future<void> handleMessageBackground(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseService().showNotification(message);
}
