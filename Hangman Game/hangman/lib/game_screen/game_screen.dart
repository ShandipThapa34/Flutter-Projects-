import 'package:flutter/material.dart';
import 'package:hangman/const/categories.dart';
import 'package:hangman/const/const.dart';
import 'package:hangman/game_screen/home_screen.dart';
import 'package:hangman/game_widgets/figure_widget.dart';
import 'package:hangman/game_widgets/hidden_letter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var characters = "abcdefghijklmnopqrstuvwxyz".toUpperCase();
  Map<String, String> wordAndCategory = Category().getRandomWordAndCategory();

  List<String> selectedChar = [];
  var tries = 0;
  var score = 0;

  bool checkWinCondition(String word, List<String> selectedChar) {
    Set<String> uniqueChars = Set.of(word.split(""));
    return uniqueChars.every((char) => selectedChar.contains(char));
  }

  bool checkLoseCondition(var tries) {
    return tries == 6 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    var category = wordAndCategory['category']!.toUpperCase();
    var word = wordAndCategory['word']!.toUpperCase();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text("Score: $score"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      figure(GameUI.hang, tries >= 0),
                      figure(GameUI.head, tries >= 1),
                      figure(GameUI.body, tries >= 2),
                      figure(GameUI.leftArm, tries >= 3),
                      figure(GameUI.rightArm, tries >= 4),
                      figure(GameUI.leftLeg, tries >= 5),
                      figure(GameUI.rightLeg, tries >= 6),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: word
                              .split("")
                              .map(
                                (e) => hiddenLetter(
                                  e,
                                  !selectedChar.contains(e.toUpperCase()),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                crossAxisCount: 7,
                children: characters.split("").map((e) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                    onPressed: selectedChar.contains(e.toUpperCase())
                        ? null
                        : () {
                            setState(() {
                              selectedChar.add(e.toUpperCase());
                              if (!word.split("").contains(e.toUpperCase())) {
                                tries++;
                              }

                              //if win condition is true
                              if (checkWinCondition(word, selectedChar)) {
                                if (tries == 0) {
                                  score = score + 60;
                                } else if (tries == 1) {
                                  score = score + 50;
                                } else if (tries == 2) {
                                  score = score + 40;
                                } else if (tries == 3) {
                                  score = score + 30;
                                } else if (tries == 4) {
                                  score = score + 20;
                                } else {
                                  score = score + 10;
                                }
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.bgColor,
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      title: const Text(
                                          "Congratulations!, you guessed the word correctly!"),
                                      content: Text("You scored: $score"),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black54),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text("Go to Home"),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black54),
                                          onPressed: () {
                                            setState(() {
                                              tries = 0;
                                              selectedChar.clear();
                                              wordAndCategory = Category()
                                                  .getRandomWordAndCategory();
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text("Next Stage"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }

                              //if lose condition is true
                              if (checkLoseCondition(tries)) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.bgColor,
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      title: const Text(
                                          "You failed to guess the word!"),
                                      content: Text("Your score is: $score"),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black54,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text("Go to Home"),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black54,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              score = 0;
                                              tries = 0;
                                              selectedChar.clear();
                                              wordAndCategory = Category()
                                                  .getRandomWordAndCategory();
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text("Try Again"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            });
                          },
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
