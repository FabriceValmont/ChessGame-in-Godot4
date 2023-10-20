extends Node

var chessBoard = []
var piece_white = [null,null,"RookWhite","KnightWhite","BishopWhite","QueenWhite","KingWhite","BishopWhite2","KnightWhite2","RookWhite2"]
var piece_black = [null,null,"RookBlack","KnightBlack","BishopBlack","QueenBlack","KingBlack","BishopBlack2","KnightBlack2","RookBlack2"]
var attack_piece_white_on_the_chessboard = []
var attack_piece_black_on_the_chessboard = []

var one_move_case = 100
var turnWhite = true
var update_of_the_parts_attack = false

func _ready():
	createBoard(12,12)
	initialisingChessBoard()
	createAttackBoardWhiteAndBlack(12,12)
	initialisingAttackBoardWhiteAndBlack()

func _process(delta):
	if turnWhite == true:
#		get_node("/root/ChessBoard/Camera2D").set_rotation_degrees(0)
		if update_of_the_parts_attack == false:
			updateAttackWhiteandBlack(turnWhite)
			attack_pieces_black()
			
			update_of_the_parts_attack = true
			
	elif turnWhite == false:
#		get_node("/root/ChessBoard/Camera2D").set_rotation_degrees(180)
		if update_of_the_parts_attack == true:
			updateAttackWhiteandBlack(turnWhite)
			attack_pieces_white()
			update_of_the_parts_attack = false

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
			if chessBoard[i][j] ==  null:
				chessBoard[i][j] = "x"
	
	print("ChessBoard: ")
	for i in range(0,12):
		print(chessBoard[i])

func createAttackBoardWhiteAndBlack(rowSize,columnSize):
	for i in range(rowSize):
		var row = []
		for j in range(columnSize):
			row.append(null)
		attack_piece_white_on_the_chessboard.append(row)
		
	for i in range(rowSize):
		var row = []
		for j in range(columnSize):
			row.append(null)
		attack_piece_black_on_the_chessboard.append(row)
	#	print(attack_piece_white_on_the_chessboard)
	#	print(attack_piece_black_on_the_chessboard)

func initialisingAttackBoardWhiteAndBlack():
	for i in range(2,10): 
		for j in range(2,10):
			attack_piece_white_on_the_chessboard[i][j] = 0
			attack_piece_black_on_the_chessboard[i][j] = 0

	for i in range(0,12):
		for j in range(0,12):
			if attack_piece_white_on_the_chessboard[i][j] ==  null:
				attack_piece_white_on_the_chessboard[i][j] = -9
	
	for i in range(0,12):
		for j in range(0,12):
			if attack_piece_black_on_the_chessboard[i][j] ==  null:
				attack_piece_black_on_the_chessboard[i][j] = -9
	
	printAttackWhite()
	printAttackBlack()

func updateAttackWhiteandBlack(color):
	if color == true:
		for i in range(2,10): 
			for j in range(2,10):
				attack_piece_white_on_the_chessboard[i][j] = 0
	else:
		for i in range(2,10): 
			for j in range(2,10):
				attack_piece_black_on_the_chessboard[i][j] = 0

func printAttackWhite():
	print("AttackBoardWhite: ")
	for i in range(0,12):
		print(attack_piece_white_on_the_chessboard[i])

func printAttackBlack():
	print("AttackBoardBlack: ")
	for i in range(0,12):
		print(attack_piece_black_on_the_chessboard[i])

func attack_pieces_white():
	for i in range(12):
		for j in range(12):
			if chessBoard[i][j] == "PawnWhite":
				if chessBoard[i-1][j+1] != "x":
					attack_piece_white_on_the_chessboard[i-1][j+1] += 1
					
				if chessBoard[i-1][j-1] != "x":
					attack_piece_white_on_the_chessboard[i-1][j-1] += 1
					
	printAttackWhite()

func attack_pieces_black():
	for i in range(12):
		for j in range(12):
			if chessBoard[i][j] == "PawnBlack":
				if chessBoard[i+1][j+1] != "x":
					attack_piece_black_on_the_chessboard[i+1][j+1] += 1
					
				if chessBoard[i+1][j-1] != "x":
					attack_piece_black_on_the_chessboard[i+1][j-1] += 1
					
	printAttackBlack()
