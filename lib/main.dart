import 'package:chatgpt/providers/chats_provider.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constans/constants.dart';
import 'screeens/chat_screen.dart';

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
        ChangeNotifierProvider(
            create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
            create: (_) => ChatsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ChatGPT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor,
          )
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
