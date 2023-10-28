import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YouWonScreen extends StatelessWidget {
  const YouWonScreen({super.key, required this.hasPlayerWon, this.function});
  final bool hasPlayerWon;
  final function;

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
    return hasPlayerWon
        ? Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.2),
                child: Text(
                  "YOU WON",
                  style: gameFont,
                ),
              ),
              GestureDetector(
                onTap: function,
                child: Container(
                  alignment: const Alignment(0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Play Again",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
