import 'dart:io';

class Piece {
  int position;
  String colour;

  Piece(String color) {
    this.colour = color;
    this.position = -1;
  }
}

class SinglePlayer {
  List<Piece> piece;
  String colour;
  int noOfPiecesInHome;
  int noOfPiecesInBox;
  int rank;
  int playerNo;

  SinglePlayer(String color, int playerNo) {
    this.colour = color;
    //Adding Four Pieces
    piece = new List<Piece>();

    piece.add(new Piece(color));
    piece.add(new Piece(color));
    piece.add(new Piece(color));
    piece.add(new Piece(color));
    this.rank = 0;
    this.noOfPiecesInHome = 0;
    this.noOfPiecesInBox = 4;
    this.playerNo = playerNo;
  }

  bool isInHome(Piece piece) {
    if (piece.position == 56) return true;
    return false;
  }

  bool isSafe(int pieceNoToMove) {
    if (this.piece[pieceNoToMove].position == -1 ||
        this.piece[pieceNoToMove].position == 0 ||
        this.piece[pieceNoToMove].position == 8 ||
        this.piece[pieceNoToMove].position == 13 ||
        this.piece[pieceNoToMove].position == 21 ||
        this.piece[pieceNoToMove].position == 26 ||
        this.piece[pieceNoToMove].position == 39 ||
        this.piece[pieceNoToMove].position == 47 ||
        this.piece[pieceNoToMove].position > 50) return true;
    return false;
  }

  void decrementNoOfPiecesInBox() {
    this.noOfPiecesInBox--;
    //piece.position=0;
  }

  void incrementNoOfPiecesInBox(Piece piece) {
    this.noOfPiecesInBox++;
    piece.position = -1;
  }

  void incrementNoOfPiecesInHome() {
    this.noOfPiecesInHome++;
  }

  int incrementPiecePosition(Piece piece, int noOnDice) {
    piece.position += noOnDice;
    return piece.position;
  }

  void setColour(String colour) {
    this.colour = colour;
    this.piece[0].colour = colour;
    this.piece[1].colour = colour;
    this.piece[2].colour = colour;
    this.piece[3].colour = colour;
  }

  int getPlayerNo() => this.playerNo;

  String getPlayerChoseColor() => this.colour;

  void setPiecePosition(int pieceNo, int position) {
    this.piece[pieceNo].position = position;
  }

  void setRank(int rank) {
    this.rank = rank;
  }

  int getRank() => this.rank;

  void printPiecePositions(int i) {
    print(
        "player $this.playerNo  ,   colour :  ${this.colour}  Pieces position [ 1 => ${this.piece[0].position} , 2 => ${this.piece[1].position} , 3 => ${this.piece[2].position} , 4 => ${this.piece[3].position}   ]");
  }

//  bool movePiece(int pieceNo,int noOnDice)
//  { if(pieceNo>3||pieceNo<0)
//      { print("Invalid piece");
//        return true;
//      }
//    if(pieceNo==)
//      return false;
//    return false;
//  }
}
