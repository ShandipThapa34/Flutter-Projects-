import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoverScreen extends StatelessWidget {
  const CoverScreen({super.key, required this.hasGameStarted});

  final bool hasGameStarted;

  //font
  static var gameFont = GoogleFonts.pressStart2p(
    textStyle: const TextStyle(
      color: Colors.deepPurple,
      fontSize: 28,
      letterSpacing: 0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container()
        : Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.5),
                child: Text("BRICK BREAKER", style: gameFont),
              ),
              Container(
                alignment: const Alignment(0, -0.2),
                child: const Text(
                  "Tap to play",
                  style: TextStyle(
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          );
  }
}
