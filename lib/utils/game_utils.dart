import 'dart:math';

import 'package:flutter/material.dart';

import 'log_utils.dart';

class GameUtils {
  static const _rock = 0;
  static const _paper = 1;
  static const _scissor = 2;

  static int getComputerChoice() {
    var random = Random();
    int choice = random.nextInt(3); // Generates a random number between 0 and 2
    printInfo("Com: $choice");

    return choice;
  }

  static String determineWinner(int playerChoice, int computerChoice) {
    String playerTitle = _getTitle(playerChoice);
    String comTitle = _getTitle(computerChoice);
    printInfo("determineWinner: Player:$playerTitle = Com:$comTitle");
    if (playerChoice == computerChoice) {
      print('It\'s a tie!');
      return 'It\'s a tie!';
    } else if ((playerChoice == _rock && computerChoice == _scissor) ||
        (playerChoice == _paper && computerChoice == _rock) ||
        (playerChoice == _scissor && computerChoice == _paper)) {
      return 'You win!\n$playerTitle beats $comTitle';
    } else {
      return 'You lose!\n$comTitle beats $playerTitle';
    }
  }

  static String _getTitle(int choice) {
    if (choice == _rock) {
      return 'Rock';
    } else if (choice == _paper) {
      return "Paper";
    } else {
      return "Scissor";
    }
  }

  static Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
