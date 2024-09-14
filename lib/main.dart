import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/ui/auth/login/login_screen.dart';
import 'package:todo_list/ui/auth/register/register_screen.dart';
import 'package:todo_list/ui/home/home_screen.dart';
import 'package:todo_list/ui/home/providers/auth_provider.dart';
import 'package:todo_list/ui/home/providers/list_provider.dart';
import 'package:todo_list/ui/splash/splash_screen.dart';
import 'my_theme.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListProvider(),),
        ChangeNotifierProvider(create: (context) =>AuthenticationProvider())
      ]
      ,
      child:TodoList()
  )
  );
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo list',
      theme:MyTheme.lightTheme,
      routes: {
        RegisterScreen.routeName : (_)=>RegisterScreen(),
        SplashScreen.routeName : (_)=>SplashScreen(),
        LoginScreen.routeName : (_)=>LoginScreen(),
        HomeScreen.routeName:(context) => HomeScreen(),
      },
      initialRoute: SplashScreen.routeName);
  }
}

