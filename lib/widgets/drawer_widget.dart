import 'package:chatgpt/screeens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../constans/constants.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_header, _menu],
      ),
    );
  }

  Widget get _header {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(color: scaffoldBackgroundColor),
        child: SafeArea(
          child: StreamBuilder(
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black12,
                          child: Text(
                            "+",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("New chat",
                                  style: TextStyle(color: Colors.white, fontSize: 22)),
                              SizedBox(height: 5),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }),
        ));
  }

  Widget get _menu {
    return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTile(
                leading: const Icon(Icons.chat),
                title: const Text('Chats', style: TextStyle(color: Colors.white)),
                collapsedTextColor: Colors.white,
                children: [
                  ListTile(
                    title: const Text('Personal chat', style: TextStyle(color: Colors.white)),
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));},
                  ),
                  ListTile(
                    title: const Text('Other chat', style: TextStyle(color: Colors.white)),
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));},
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));},
              ),
              ListTile(
                leading: const Icon(Icons.light_mode_outlined),
                title: const Text('Light mode', style: TextStyle(color: Colors.white)),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));},
              ),
            ],
          ),
        ),
    );
  }
}