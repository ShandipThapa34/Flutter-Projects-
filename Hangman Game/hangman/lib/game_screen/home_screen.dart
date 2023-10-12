import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman/const/const.dart';
import 'package:hangman/game_screen/game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppColors.bgColor,
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              title: const Text("Do you want to exit?"),
              actions: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text("Yes"),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            const Text(
              "Hangman: The Game",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Image.asset(GameUI.gameHOme),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameScreen(),
                    ),
                  );
                },
                child: const Text("Start Game")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Exit Game"),
            ),
          ],
        ),
      ),
    );
  }
}
