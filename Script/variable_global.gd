extends Node
var one_move_case = 100

# Created chessboard
var chessBoard = []
var piece_white = [null,null,"rook_white","knight_white","bishop_white","queen_white","king_white","bishop_white","knight_white","rook_white"]
var piece_black = [null,null,"rook_black","knight_black","bishop_black","queen_black","king_black","bishop_black","knight_black","rook_black"]

func _ready():
	createBoard(12,12)
	initialisingChessBoard()

func _process(delta):
	pass

func createBoard(rowSize,columnSize):
	for i in range(rowSize):
		var row = []
		for j in range(columnSize):
			row.append(null)
		chessBoard.append(row)
	
#	print(chessBoard)
#	print("ChessBoard created. Size: ", rowSize, "x", columnSize)

func initialisingChessBoard():
	for i in range(2,3):
		for j in range(2,10):
			chessBoard[i][j] = piece_black[j]
	for j in range(2, 10):
		chessBoard[3][j] = "pawn_black"
	for i in range(4,8): 
		for j in range(2,10):
			chessBoard[i][j] = "0"
	for j in range(2, 10):
		chessBoard[8][j] = "pawn_white"
	for i in range(9,10): 
		for j in range(2,10):
			chessBoard[i][j] = piece_white[j]
	for i in range(0,12):
		for j in range(0,12):
			if chessBoard[i][j] ==  null :
				chessBoard[i][j] = "x"
	
#	for i in range(0,12):
##		print(chessBoard[i])
