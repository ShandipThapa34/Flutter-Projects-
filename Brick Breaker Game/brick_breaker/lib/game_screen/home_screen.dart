import 'dart:async';

import 'package:brick_breaker/game_element/ball.dart';
import 'package:brick_breaker/game_element/brick.dart';
import 'package:brick_breaker/game_screen/cover_screen.dart';
import 'package:brick_breaker/game_screen/gameover_screen.dart';
import 'package:brick_breaker/game_element/player.dart';
import 'package:brick_breaker/game_screen/youWon_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //ball variables
  double ballX = 0;
  double ballY = 0;
  double ballXIncrements = 0.006;
  double ballYIncrements = 0.005;
  var ballXDirection = direction.LEFT;
  var ballYDirection = direction.DOWN;

  //player variables
  double playerX = -0.2;
  double playerWidth = 0.4; //out of 2

  //brick variables
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4; //out of 2
  static double brickHeight = 0.05; //out of 2
  static double brickGap = 0.01;
  static int numberOfBricksInRow = 3;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * brickWidth -
          (numberOfBricksInRow - 1) * brickGap);
  bool brickBroken = false;

  List myBricks = [
    //[x, y, broken = true/false]
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false]
  ];

  //game settings
  bool hasGameStarted = false;
  bool isGameOver = false;
  bool hasPlayerWon = false;

  //start game
  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      //update direction
      updateDirection();

      //move ball
      moveBall();

      //check if player dead
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      //check if player won
      if (playerWinOrNot()) {
        timer.cancel();
        hasPlayerWon = true;
      }

      //check if brick broken
      checkForBrokenBrick();
    });
  }

  //is brick got hit
  void checkForBrokenBrick() {
    //checks for when ball hits bottom of brick
    for (int i = 0; i < myBricks.length; i++) {
      if (ballX >= myBricks[i][0] &&
          ballX <= myBricks[i][0] + brickWidth &&
          ballY <= myBricks[i][1] + brickHeight &&
          myBricks[i][2] == false) {
        setState(() {
          myBricks[i][2] = true;

          //since brick is broken, update direction of the ball
          //based on which side of the brick it hit
          //to do this, calculate the distance of the ball from each of 4 side
          //the smallest distance is the side the ball has hit

          double leftSideDist = (myBricks[i][0] - ballX).abs();
          double rightSideDist = (myBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (myBricks[i][1] - ballY).abs();
          double bottomSideDist = (myBricks[i][1] + brickHeight - ballY).abs();

          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);

          switch (min) {
            case 'left':
              ballXDirection = direction.LEFT;
              break;
            case 'right':
              ballXDirection = direction.RIGHT;
              break;
            case 'up':
              ballYDirection = direction.UP;
              break;
            case 'down':
              ballYDirection = direction.DOWN;
              break;
          }
        });
      }
    }
  }

  //return the smallest side
  String findMin(double a, double b, double c, double d) {
    List<double> myList = [
      a,
      b,
      c,
      d,
    ];
    double currentMin = a;

    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'top';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'down';
    }

    return '';
  }

  //is player dead
  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    } else {
      return false;
    }
  }

  bool playerWinOrNot() {
    if (myBricks[0][2] == true &&
        myBricks[1][2] == true &&
        myBricks[2][2] == true) {
      return true;
    } else {
      return false;
    }
  }

  //move ball
  void moveBall() {
    setState(() {
      //move horizontally
      if (ballXDirection == direction.LEFT) {
        ballX -= ballXIncrements;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += ballXIncrements;
      }

      //move vertically
      if (ballYDirection == direction.DOWN) {
        ballY += ballYIncrements;
      } else if (ballYDirection == direction.UP) {
        ballY -= ballYIncrements;
      }
    });
  }

  //update direction of the ball
  void updateDirection() {
    setState(() {
      //ball goes up when it hits the player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = direction.UP;
      }
      //ball goes down when it hits the top of screen
      else if (ballY <= -1) {
        ballYDirection = direction.DOWN;
      }

      //ball goes left if it hits the right wall
      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      }
      //ball goes right if it hits the left wall
      else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  //move player left
  void moveLeft() {
    setState(() {
      //move left if player don't go outside the screen
      if (!(playerX - 0.2 < -1)) {
        playerX -= 0.2;
      }
    });
  }

  //move player right
  void moveRight() {
    setState(() {
      //move left if player don't go outside the screen
      if (!(playerX + playerWidth >= 1)) {
        playerX += 0.2;
      }
    });
  }

  //resets game if play hit play again
  void resetGame() {
    setState(() {
      playerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;
      hasPlayerWon = false;

      myBricks = [
        //[x, y, broken = true/false]
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Center(
            child: Stack(
              children: [
                //tap to play
                CoverScreen(
                  hasGameStarted: hasGameStarted,
                ),

                //is player dead
                GameOverScreen(
                  isGameOver: isGameOver,
                  function: resetGame,
                ),

                YouWonScreen(
                  hasPlayerWon: hasPlayerWon,
                  function: resetGame,
                ),

                //ball
                MyBall(
                  ballX: ballX,
                  ballY: ballY,
                  hasGameStarted: hasGameStarted,
                  isGameOver: isGameOver,
                ),

                //player
                MyPlayer(
                  playerX: playerX,
                  playerWidth: playerWidth,
                ),

                //bricks
                MyBrick(
                  brickX: myBricks[0][0],
                  brickY: myBricks[0][1],
                  brickBroken: myBricks[0][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                ),
                MyBrick(
                  brickX: myBricks[1][0],
                  brickY: myBricks[1][1],
                  brickBroken: myBricks[1][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                ),
                MyBrick(
                  brickX: myBricks[2][0],
                  brickY: myBricks[2][1],
                  brickBroken: myBricks[2][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
