extends Node
var one_move_case = 100
var turnWhite = true

# Created chessboard
var chessBoard = []
var piece_white = [null,null,"RookWhite","KnightWhite","BishopWhite","QueenWhite","KingWhite","BishopWhite2","KnightWhite2","RookWhite2"]
var piece_black = [null,null,"RookBlack","KnightBlack","BishopBlack","QueenBlack","KingBlack","BishopBlack2","KnightBlack2","RookBlack2"]

func _ready():
	createBoard(12,12)
	initialisingChessBoard()

func _process(delta):
#	if turnWhite == true:
#		get_node("/root/ChessBoard/Camera2D").set_rotation_degrees(0)
#	else:
#		get_node("/root/ChessBoard/Camera2D").set_rotation_degrees(180)
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
	for j in range(3, 10):
		chessBoard[3][2] = "PawnBlack"
		chessBoard[3][j] = "PawnBlack" + str(j-1)
	for i in range(4,8): 
		for j in range(2,10):
			chessBoard[i][j] = "0"
	for j in range(3, 10):
		chessBoard[8][2] = "PawnWhite"
		chessBoard[8][j] = "PawnWhite" + str(j-1)
	for i in range(9,10): 
		for j in range(2,10):
			chessBoard[i][j] = piece_white[j]
	for i in range(0,12):
		for j in range(0,12):
			if chessBoard[i][j] ==  null :
				chessBoard[i][j] = "x"
	
	for i in range(0,12):
		print(chessBoard[i])
