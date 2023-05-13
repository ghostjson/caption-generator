
import 'dart:convert';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:visual/home.dart';
import 'package:visual/server.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Box box = await Hive.openBox('app');

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Audio? audio;

  int currentPageIndex = 1;

  Future<void> sendRequest(String base64Image) async {
    final uri = Uri.parse('http://192.168.1.2:5000/api/generate');

    debugPrint('Make HTTP request to server (${uri.toString()})');

    // post request
    var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'image': base64Image,
          'extension': 'jpg'
        }));
    var decoded = json.decode(response.body);
    debugPrint('Got response from server with body $decoded');

     audio = Audio.loadFromRemoteUrl('http://192.168.1.2:5000/audio/${decoded['audio_id']}');
     audio?.play();
     debugPrint('Played successfully!');
  }

  Widget getPage(currentPageIndex){
    switch(currentPageIndex){
      case 0:
        return const Center(
          child: HomePage()
        );
      case 1:
        return const ServerPage();
      case 2:
        return const Placeholder();
      default:
        return const Placeholder();
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: getPage(currentPageIndex),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 8,
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(icon: Icons.home, text: 'Home',),
                GButton(icon: Icons.computer, text: 'Server'),
                GButton(icon: Icons.settings, text: 'Settings',)
              ],
              onTabChange: (index) {
                setState(() {
                  currentPageIndex = index;
                });
                debugPrint('Page changed! $index');
              },
            ),
          ),
        ),
      ),
    );
  }
}



