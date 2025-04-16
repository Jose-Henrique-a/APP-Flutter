import 'package:flutter/material.dart';
import 'package:flutterversaoweb/provider/todo_provider.dart';
import 'package:flutterversaoweb/screens/show_todo_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutterversaoweb/db_helper/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.init(); // Inicializa o Hive
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TodoProvider(),
        ),
      ],
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ShowTodoScreen(),
      ),
    );
  }
}