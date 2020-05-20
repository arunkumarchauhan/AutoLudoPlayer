import 'dart:io';
import 'dart:math';
import 'singleplayer.dart';
import 'game.dart';

main() {
  int noOfPlayers = 0;

  print("Enter No of players :\n");
  noOfPlayers = int.parse(stdin.readLineSync());
  if (noOfPlayers > 4) throw Exception("NO of players cannot be more than 4\n");
  List<SinglePlayer> player = List<SinglePlayer>();

  List<String> colorsAvailable = ['blue', 'green', 'yellow', 'red'];
  for (int i = 0; i < noOfPlayers; i++) {
    print("\nPlayer $i choose colour\n");
    print(colorsAvailable);
    String chosenColor = stdin.readLineSync();
    player.add(new SinglePlayer(chosenColor, i + 1));
    colorsAvailable.remove(chosenColor);
  }
  for (int i = 0; i < noOfPlayers; i++) {
    player[i].printPiecePositions(i);
  }

  Game game = new Game(player, noOfPlayers);
  game.playGame();
  print(
      "===============================================RESULT=================================================");
  game.printGameResult();
}
