import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:school_erp/bloc/bloc_observable.dart';
import 'package:school_erp/firebase_options.dart';
import 'package:school_erp/model/user_model.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_create_account.dart';
import 'package:school_erp/screens/student_screens/home_screen.dart';
import 'package:school_erp/screens/login_screens/login_screen.dart';
import 'package:school_erp/screens/splash_screen.dart';
import 'package:school_erp/screens/login_screens/user_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = const ObserverBloc();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Box<UserModel> userBox = Hive.box<UserModel>('users');

  @override
  void initState() {
    Hive.openBox<UserModel>('users');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // home: userBox.values.isNotEmpty ? const HomeScreen() : const LoginScreen(),
      home: const SplashScreen(),
    );
  }
}