import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/providers/chatProvider.dart';
import 'package:chat_gpt/providers/modelsProvider.dart';
import 'package:chat_gpt/screens/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModelsProvider() ),
         ChangeNotifierProvider(create: (_) => ChatProvider() )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme:const AppBarTheme(color: cardColor),
         scaffoldBackgroundColor: scafoldBackgroundColor,
          
          useMaterial3: true,
        ),
        home:const ChatScreen()
      ),
    );
  }
}
