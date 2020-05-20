import 'dart:io';
import 'dart:math';
import 'singleplayer.dart';

class Game {
  List<SinglePlayer> player;
  int noOfPlayers;
  int noOfPlayersPassed;

  List<SinglePlayer> playersExited;
  List<SinglePlayer> playersListForCheckingCut;

  Game(List<SinglePlayer> player, int noOfPlayers) {
    playersListForCheckingCut = new List<SinglePlayer>();
    this.player = player;
    this.noOfPlayers = noOfPlayers;
    this.noOfPlayersPassed = 0;
    playersListForCheckingCut = copyList(player);
  }

  void playGame() {
    int noOnDice = 0;
    int rank = 0;
    this.playersExited = List<SinglePlayer>();
    while (this.noOfPlayersPassed < this.noOfPlayers - 1) {
      for (int i = 0; i < this.noOfPlayers - this.noOfPlayersPassed; i++) {
        //player[i].printPiecePositions(i);
        int prevNoOnDice = 0;
        int sixCount = 0;
        dynamic extraChance = false;
        bool disableDice = false;
        do {
          print(
              "#######################################################################################################################");
          //Handling if chose wrong piece to move
          if (disableDice == false)
            noOnDice = Random().nextInt(6) + 1;
          else
            noOnDice = prevNoOnDice;

          //printing current piece positions
          player[i].printPiecePositions(i);

          //to count no of sixes in one consecutive play by one player
          if (noOnDice == 6) {
            sixCount++;
          }
          //to avoid getting three sixes in one consecutive play
          if (sixCount == 3) {
            noOnDice -= 1;
          }

          print("No on your dice is $noOnDice");

          //If all pieces are inside Box and Outcome On Dice is not 6 "Or" no piece in  path to advance
          if ((noOnDice != 6 && player[i].noOfPiecesInBox == 4) ||
              (player[i].noOfPiecesInHome != 4 &&
                  player[i].noOfPiecesInBox != 4 &&
                  (player[i].noOfPiecesInBox + player[i].noOfPiecesInHome) ==
                      4)) {
            print("You Cannot Play any move .Dice Passed");
            break;
          }

          print("Choose piece to move  .Positions are as below ");

          // int pieceNoToMove= int.parse(stdin.readLineSync());

          int pieceNoToMove = Random().nextInt(4);
          print("Choosen Piece Number To Move : ${pieceNoToMove + 1}");

          extraChance = movePiece(noOnDice, i, pieceNoToMove);

          if (extraChance == "Chosen Piece Cannot Move") {
            disableDice = true;
          }
          print("After Move  Positions");
          player[i].printPiecePositions(i);
          if (player[i].noOfPiecesInHome == 4) {
            rank += 1;
            this.noOfPlayersPassed += 1;
            player[i].rank = rank;
            playersListForCheckingCut.remove(player[i]);
            this.playersExited.add(player[i]);
            player.remove(player[i]);
          }

          prevNoOnDice = noOnDice;
        } while (extraChance != false);
      }
    }
    player[0].setRank(this.noOfPlayers);
    playersExited.add(player[0]);
  }

  void printGameResult() {
    for (int i = 0; i < this.noOfPlayers; i++) {
      print(
          " Player Number ${this.playersExited[i].getPlayerNo()} , Color :  ${this.playersExited[i].getPlayerChoseColor()}  ,  Rank : ${this.playersExited[i].getRank()} ");
    }
  }

  List<SinglePlayer> copyList(List<SinglePlayer> list) {
    List<SinglePlayer> tempList = new List<SinglePlayer>();
    for (SinglePlayer p in list) {
      tempList.add(p);
    }
    return tempList;
  }

  dynamic movePiece(int noOnDice, int playerNo, int pieceNoToMove) {
    // Check For Wrong Piece No.
    if (pieceNoToMove < 0 || pieceNoToMove > 3) {
      print("Invalid piece");
      return true;
    }

    int currPlayerPiecePos =
        this.player[playerNo].piece[pieceNoToMove].position;
    List<SinglePlayer> tempPlayersList =
        copyList(this.playersListForCheckingCut);
    tempPlayersList.remove(this.player[playerNo]);

    //Piece Inside intial box and want to land piece in game
    if (noOnDice == 6 && currPlayerPiecePos == -1) {
      print("Piece ${pieceNoToMove + 1} Landed to start position 0");
      this.player[playerNo].setPiecePosition(pieceNoToMove, 0);
      this.player[playerNo].noOfPiecesInBox -= 1;
      print("Earned Extra chance Play Again");
      return true;
    }

//Piece already in Home
    if (currPlayerPiecePos >= 56) {
      print("Piece ${pieceNoToMove + 1} Already In Home Cannot Move");
      return "Chosen Piece Cannot Move";
    }
    // Check if Piece Entering Home
    if (currPlayerPiecePos + noOnDice == 56) {
      this.player[playerNo].piece[pieceNoToMove].position = 56;
      this.player[playerNo].noOfPiecesInHome += 1;
      if (this.player[playerNo].noOfPiecesInHome == 4) return false;
      print("Earned Extra chance for Goaling Piece in Home");
      return true;
    }

    //if Chosen piece is not opened
    if (currPlayerPiecePos == -1) {
      print(
          "Cannot Move Non Opened  piece.Chosen  Piece Position$currPlayerPiecePos ");
      return "Chosen Piece Cannot Move";
    }

    //Piece in Path
    if (currPlayerPiecePos + noOnDice < 51) {
      this.player[playerNo].piece[pieceNoToMove].position =
          currPlayerPiecePos + noOnDice;

      //Handling if player is attacking on double piece
//      if(haveAttackedOnDoublePiece(noOnDice,playerNo,pieceNoToMove,tempPlayersList))
//      { return false;
//
//      }

      print(
          "POSITION OF ACTIVE PLAYER AFTER UPDATION ${this.player[playerNo].piece[pieceNoToMove].position}");
      return checknCutOthersPiece(
          playerNo, pieceNoToMove, noOnDice, tempPlayersList);
    }
    if ((currPlayerPiecePos + noOnDice) < 56 &&
        (currPlayerPiecePos + noOnDice) > 50) {
      this.player[playerNo].piece[pieceNoToMove].position =
          currPlayerPiecePos + noOnDice;
      return false;
    }

    return true;
  }

  bool haveAttackedOnDoublePiece(int noOnDice, int playerNo, int pieceNoToMove,
      List<SinglePlayer> tempPlayersList) {
    if (this.player[playerNo].isSafe(pieceNoToMove))
      return false;
    else {}
    return false;
  }

  void cutPiece(String clr, int pieceNo) {
    print("CUT PIECE");
    for (int i = 0; i < player.length; i++) {
      if (this.player[i].colour == clr) {
        this.player[i].printPiecePositions(i);

        this.player[i].piece[pieceNo].position = -1;
        this.player[i].noOfPiecesInBox++;
        print(
            "Earned Extra Chance To Cut ${this.player[i].colour}  piece number${pieceNo + 1}");
        this.player[i].printPiecePositions(i);

        break;
      }
    }
  }

  bool checknCutOthersPiece(int playerNo, int pieceNoToMove, int noOnDice,
      List<SinglePlayer> tempPlayersList) {
    if (this.player[playerNo].isSafe(pieceNoToMove)) {
      print("AT SAFE POSITION");
      return false;
    } else {
      int originalListPiecePosition =
          this.player[playerNo].piece[pieceNoToMove].position;

      for (int i = 0; i < tempPlayersList.length; i++) {
        for (int j = 0; j < 4; j++) {
          print("INSIDE FOR");
          //check if player color is Blue who the rolled dice
          if (this.player[playerNo].colour == "blue") {
            //Temporary list piece position
            int pos = tempPlayersList[i].piece[j].position;

            print(
                "TEMP POSITION [ $i ] [ $j ] => $pos  ${tempPlayersList[i].colour} ");
            //to check if position of piece is not in home safe path or in player initial box

            if (pos != -1 && pos < 51) {
              //check if red dice is getting cut
              if (tempPlayersList[i].colour == "red" &&
                  (pos - 13) == originalListPiecePosition) {
                cutPiece("red", j);
                return true;
              }
              if (tempPlayersList[i].colour == "yellow" &&
                  (pos - 26) == originalListPiecePosition) {
                cutPiece("yellow", j);
                return true;
              }

              if (tempPlayersList[i].colour == "green" &&
                  (pos - 39) == originalListPiecePosition) {
                cutPiece("green", j);
                return true;
              }
              print("BLUE ELSE");
            }
          }

          //check if player color is Red who the rolled dice

          if (this.player[playerNo].colour == "red") {
            int pos = tempPlayersList[i].piece[j].position;

            if (pos != -1 &&
                pos <
                    51) //to check if position of piece is not in home safe path or in player initial box
            {
              {
                //check if yellow dice is getting cut

                if (tempPlayersList[i].colour == "yellow" &&
                    (pos - 13) == originalListPiecePosition) {
                  cutPiece("yellow", j);
                  return true;
                }
                if (tempPlayersList[i].colour == "green" &&
                    (pos - 26) == originalListPiecePosition) {
                  cutPiece("green", j);
                  return true;
                }

                if (tempPlayersList[i].colour == "blue" &&
                    (pos - 39) == originalListPiecePosition) {
                  cutPiece("blue", j);
                  return true;
                }
                print("RED ELSE");
              }
            }

            if (this.player[playerNo].colour == "yellow") {
              int pos = tempPlayersList[i].piece[j].position;

              if (pos != -1 &&
                  pos <
                      51) //to check if position of piece is not in home safe path or in player initial box
              {
                if (tempPlayersList[i].colour == "green" &&
                    (pos - 13) == originalListPiecePosition) {
                  cutPiece("green", j);
                  return true;
                }
                if (tempPlayersList[i].colour == "blue" &&
                    (pos - 26) == originalListPiecePosition) {
                  cutPiece("blue", j);
                  return true;
                }

                if (tempPlayersList[i].colour == "red" &&
                    (pos - 39) == originalListPiecePosition) {
                  cutPiece("red", j);
                  return true;
                }
                print("YELLOW ELSE");
              }
            }

            if (this.player[playerNo].colour == "green") {
              int pos = tempPlayersList[i].piece[j].position;

              if (pos != -1 &&
                  pos <
                      51) //to check if position of piece is not in home safe path or in player initial box
              {
                if (tempPlayersList[i].colour == "blue" &&
                    (pos - 13) == originalListPiecePosition) {
                  cutPiece("blue", j);
                  return true;
                }
                if (tempPlayersList[i].colour == "red" &&
                    (pos - 26) == originalListPiecePosition) {
                  cutPiece("red", j);
                  return true;
                }

                if (tempPlayersList[i].colour == "yellow" &&
                    (pos - 39) == originalListPiecePosition) {
                  cutPiece("yellow", j);
                  return true;
                }
                print("GREEN ELSE");
              }
            }
          }
        }
      }
    }
    return false;
  }
}
