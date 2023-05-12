
import 'dart:convert';
import 'dart:io';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:visual/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

int currentPageIndex = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Audio? audio;

  int currentPageIndex = 0;

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


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.green,
      child: Stack(
        children: [
          const Positioned.fill(
              child: CameraApp()
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 20),
                child: const FloatingActionButton(
                  onPressed: null,
                  backgroundColor: Color.fromRGBO(103, 58, 183, 1),
                  child: Icon(Icons.circle, color: Color.fromRGBO(31, 31, 31, 1)),
                )
              )
            ]
          )
        ],
      )
    );
  }
}

class ServerPage extends StatefulWidget {
  const ServerPage({Key? key}) : super(key: key);

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  
  var serverLive = true;
  
  Widget renderPage(serverLive) {
    if(serverLive) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/server-connected.svg'),
            const SizedBox(height: 10),
            const Text('Server Connection Established',
              style: TextStyle(
                  color: Color.fromRGBO(113, 195, 134, 1),
                  fontSize: 23,
                  fontWeight: FontWeight.bold
              ),),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      debugPrint('Update server clicked');
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                        backgroundColor: const Color.fromRGBO(103, 58, 183, 1)
                    ),
                    child: const Text(
                      'Update Server',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      );
    }else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/server-disconnected.svg'),
            const SizedBox(height: 10),
            const Text('Server Connection Lost',
              style: TextStyle(
                  color: Color.fromRGBO(237, 113, 97, 1),
                  fontSize: 23,
                  fontWeight: FontWeight.bold
              ),),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    debugPrint('Retry clicked');
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                      backgroundColor: const Color.fromRGBO(103, 58, 183, 1)
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),

                ),
                const SizedBox(width: 15,),
                ElevatedButton(
                    onPressed: (){
                      debugPrint('Update server clicked');
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                        backgroundColor: const Color.fromRGBO(103, 58, 183, 1)
                    ),
                    child: const Text(
                      'Update Server',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromRGBO(31, 31, 31, 1),
      child: renderPage(serverLive)
        // child: SvgPicture.asset('assets/server-disconnected.svg'),
    );
  }
}

