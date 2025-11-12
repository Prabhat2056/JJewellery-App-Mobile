import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:jjewellery/bloc/Order/jewellery_order_bloc.dart';
import 'package:jjewellery/bloc/QrResult/qr_result_bloc.dart';
import 'package:jjewellery/bloc/Settings/settings_bloc.dart';
import 'package:jjewellery/env_config.dart';
import 'package:jjewellery/firebase_options_prodnormal.dart';
import 'package:jjewellery/presentation/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'bloc/OldJewellery/old_jewellery_bloc.dart';
import 'firebase_options_prodsang.dart';
import 'utils/theme/app_theme.dart';

late SharedPreferences prefs;
late Database db;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeNotifications() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final title = message.notification?.title ?? "J-Jewellery";
  final body = message.notification?.body ?? "";

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics);

  await db.transaction((txn) async {
    await txn.rawInsert(
      'INSERT INTO Notifications (title, description, date) VALUES (?, ?, CURRENT_TIMESTAMP)',
      [title, body],
    );
  });
}

Future<void> mainCommon({required String env}) async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeNotifications();

  await Firebase.initializeApp(
    options: env == 'prod_sang'
        ? SangDefaultFirebaseOptions.currentPlatform
        : DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  prefs = await SharedPreferences.getInstance();
  var databasePath = await getDatabasesPath();
  String path = '$databasePath/my_database.db';

  db = await openDatabase(path, version: 1, onCreate: (db, version) async {
    await db.execute(
        'CREATE TABLE Notifications (id INTEGER PRIMARY KEY,title TEXT, description TEXT,date DATETIME)');
    await db.execute(
        'CREATE TABLE KaratSettings (id INTEGER PRIMARY KEY,karat TEXT, percentage REAL,updated_at DATETIME)');
    await db.execute(
        'CREATE TABLE ShopInfo (id INTEGER PRIMARY KEY,name Text NULL,short_name TEXT NULL, contact TEXT NULL,address TEXT NULl,pan TEXT NULL,logo TEXT NULL,updated_at DATETIME)');
    await db.execute(
        'CREATE TABLE RATES(id INTEGER PRIMARY KEY,serverId TEXT,eng_date TEXT,nep_date TEXT,gold TEXT,silver TEXT,gold_diff TEXT,silver_diff TEXT)');
    await db.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO KaratSettings (karat, percentage,updated_at) VALUES ("24K", 100, CURRENT_TIMESTAMP)');
      await txn.rawInsert(
          'INSERT INTO KaratSettings (karat, percentage,updated_at) VALUES ("22K", 91.6, CURRENT_TIMESTAMP)');
      await txn.rawInsert(
          'INSERT INTO KaratSettings (karat, percentage,updated_at) VALUES ("18k", 75, CURRENT_TIMESTAMP)');
      await txn.rawInsert(
          'INSERT INTO KaratSettings (karat, percentage,updated_at) VALUES ("14k", 58.3, CURRENT_TIMESTAMP)');
      await txn.rawInsert(
          'INSERT INTO KaratSettings (karat, percentage,updated_at) VALUES ("12k", 50, CURRENT_TIMESTAMP)');
    });
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final title = message.notification?.title ?? "J-Jewellery";
    final body = message.notification?.body ?? "";
    await db.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO Notifications (title, description, date) VALUES (?, ?, CURRENT_TIMESTAMP)',
        [title, body],
      );
    });
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  EnvConfig.env = env;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => QrResultBloc()),
        BlocProvider(create: (context) => JewelleryOrderBloc()),
        BlocProvider(create: (context) => SettingsBloc()),
        BlocProvider(create: (context) => OldJewelleryBloc()),
      ],
      child: MaterialApp(
        title: 'JJewellery',
        theme: AppTheme.appTheme,
        debugShowCheckedModeBanner: false,
        home: const Splash(),
      ),
    );
  }
}
