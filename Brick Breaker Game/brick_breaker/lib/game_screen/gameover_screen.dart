import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key, required this.isGameOver, this.function});
  final bool isGameOver;
  final function;

  //font
  static var gameFont = GoogleFonts.pressStart2p(
      textStyle: const TextStyle(
    color: Colors.deepPurple,
    fontSize: 28,
    letterSpacing: 0,
  ));

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.3),
                child: Text(
                  "GAME OVER",
                  style: gameFont,
                ),
              ),
              Container(
                alignment: const Alignment(0, 0),
                child: GestureDetector(
                  onTap: function,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Play Again",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          )
        : Container();
  }
}
