
import 'dart:convert';
import 'dart:io';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visual/camera.dart';
import 'package:http/http.dart' as http;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  Audio? audio;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera App'),
        ),
        body: const SafeArea(
          child: CameraApp(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            controller.takePicture().then((XFile? file) async {
              if(file != null){
                debugPrint("File saved to the path ${file.path}");
                
                File imageFile = File(file.path);
                Uint8List imageBytes = imageFile.readAsBytesSync();
                String base64 = base64Encode(imageBytes);

                debugPrint("Base 64 encode is $base64");
                
                await sendRequest(base64);
              }
            });
          },
          child: const Icon(Icons.camera_alt),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}


