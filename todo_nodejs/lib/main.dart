import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_nodejs/provider/auth_provider.dart';
import 'package:todo_nodejs/provider/todo_provider.dart';
import 'package:todo_nodejs/screen/auth_wrapper.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences pref=await SharedPreferences.getInstance();
  runApp( 
    MultiProvider(providers: [
     ChangeNotifierProvider(create: (__)=>AuthProvider()),
     ChangeNotifierProvider(create: (__)=>TodoProvider())
      // Add other providers here if needed
    ], child: MyApp()),
   );
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:AuthWrapper(),
    );
  }
}

