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

func updateAttackWhiteandBlack(color:bool):
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

func pawnAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard):
	for dx in [-1, 1]:
		var x = i - 1
		var y = j + dx
		if x >= 0 and y >= 0 and x < 12 and y < 12 and chessBoard[x][y] != "x":
			attack_piece_white_on_the_chessboard[x][y] += 1

func knightAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard):
	var knight_moves = [
		Vector2(-2, -1), Vector2(-2, 1),
		Vector2(-1, 2), Vector2(1, 2),
		Vector2(2, -1), Vector2(2, 1),
		Vector2(-1, -2), Vector2(1, -2)]
		
	for move in knight_moves:
		var x = i + move.x
		var y = j + move.y
		if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
			attack_piece_white_on_the_chessboard[x][y] += 1

func bishopAttackWhite(i, j, dx, dy, attack_piece_white_on_the_chessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingBlack":
				if attack_piece_white_on_the_chessboard[x + dx][y + dy] <= -1:
					attack_piece_white_on_the_chessboard[x][y] += 1
					break
				else:
					attack_piece_white_on_the_chessboard[x][y] += 1
					attack_piece_white_on_the_chessboard[x + dx][y + dy] += 1
					break
			else:
				attack_piece_white_on_the_chessboard[x][y] += 1
				break
		else:
			attack_piece_white_on_the_chessboard[x][y] += 1

func rookAttackWhite(i, j, dx, dy, attack_piece_white_on_the_chessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingBlack":
				if attack_piece_white_on_the_chessboard[x + dx][y + dy] <= -1:
					attack_piece_white_on_the_chessboard[x][y] += 1
					break
				else:
					attack_piece_white_on_the_chessboard[x][y] += 1
					attack_piece_white_on_the_chessboard[x + dx][y + dy] += 1
					break
			else:
				attack_piece_white_on_the_chessboard[x][y] += 1
				break
		else:
			attack_piece_white_on_the_chessboard[x][y] += 1

func queenAttackWhite(i, j, attack_piece_white_on_the_chessboard):
	rookAttackWhite(i, j, -1, 0, attack_piece_white_on_the_chessboard)  # Vers le haut
	rookAttackWhite(i, j, 1, 0, attack_piece_white_on_the_chessboard)  # Vers le bas
	rookAttackWhite(i, j, 0, 1, attack_piece_white_on_the_chessboard)  # Vers la droite
	rookAttackWhite(i, j, 0, -1, attack_piece_white_on_the_chessboard)  # Vers la gauche
	bishopAttackWhite(i, j, -1, 1, attack_piece_white_on_the_chessboard)  # En haut à droite
	bishopAttackWhite(i, j, -1, -1, attack_piece_white_on_the_chessboard)  # En haut à gauche
	bishopAttackWhite(i, j, 1, 1, attack_piece_white_on_the_chessboard)  # En bas à droite
	bishopAttackWhite(i, j, 1, -1, attack_piece_white_on_the_chessboard)  # En bas à gauche

func kingAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard):
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue  # Ignore la position actuelle du roi
			var x = i + dx
			var y = j + dy
				
			if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
				attack_piece_white_on_the_chessboard[x][y] += 1

func attack_pieces_white():
	for i in range(12):
		for j in range(12):
			var piece = chessBoard[i][j]
			if piece.begins_with("PawnWhite"):
				pawnAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard)
						
			if piece.begins_with("KnightWhite"):
				knightAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard)
			
			if piece.begins_with("BishopWhite"):
				bishopAttackWhite(i, j, -1, 1, attack_piece_white_on_the_chessboard)  # En haut à droite
				bishopAttackWhite(i, j, -1, -1, attack_piece_white_on_the_chessboard)  # En haut à gauche
				bishopAttackWhite(i, j, 1, 1, attack_piece_white_on_the_chessboard)  # En bas à droite
				bishopAttackWhite(i, j, 1, -1, attack_piece_white_on_the_chessboard)  # En bas à gauche
				
			if piece.begins_with("RookWhite"):
				rookAttackWhite(i, j, -1, 0, attack_piece_white_on_the_chessboard)  # Vers le haut
				rookAttackWhite(i, j, 1, 0, attack_piece_white_on_the_chessboard)  # Vers le bas
				rookAttackWhite(i, j, 0, 1, attack_piece_white_on_the_chessboard)  # Vers la droite
				rookAttackWhite(i, j, 0, -1, attack_piece_white_on_the_chessboard)  # Vers la gauche
				
			if piece.begins_with("QueenWhite"):
				queenAttackWhite(i, j, attack_piece_white_on_the_chessboard)
			
			if piece == "KingWhite":
				kingAttackWhite(i, j, chessBoard, attack_piece_white_on_the_chessboard)
				
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
