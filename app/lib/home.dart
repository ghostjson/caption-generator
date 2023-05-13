import 'package:flutter/material.dart';
import 'package:visual/camera.dart';

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
