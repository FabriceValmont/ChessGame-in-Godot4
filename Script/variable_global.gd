extends Node

var chessBoard = []
var pieceWhite = [null,null,"RookWhite","KnightWhite","BishopWhite","QueenWhite","KingWhite","BishopWhite2","KnightWhite2","RookWhite2"]
var pieceBlack = [null,null,"RookBlack","KnightBlack","BishopBlack","QueenBlack","KingBlack","BishopBlack2","KnightBlack2","RookBlack2"]
var attackPieceWhiteOnTheChessboard = []
var attackPieceBlackOnTheChessboard = []

var oneMoveCase = 100
var turnWhite = true
var updateOfThePartsAttack = false
var directionOfAttack = "Aucune"
var attackerPositioni
var attackerPositionj
var checkWhite = false
var checkBlack = false
var pieceProtectTheKing = false
var threatened = false
var stalemate = true
var checkmate = false

func _ready():
	createBoard(12,12)
	initialisingChessBoard()
	createAttackBoardWhiteAndBlack(12,12)
	initialisingAttackBoardWhiteAndBlack()

func _process(delta):
	await get_tree().process_frame
	if turnWhite == true:
		if updateOfThePartsAttack == false:
			updateAttackWhiteandBlack()
			attackPiecesWhite()
			attackPiecesBlack()
			enPassantFinish()
			verificationCheckAndCheckmate()
			verificationStalemate("Black", "PawnWhite","KnightWhite","BishopWhite","RookWhite","QueenWhite",attackPieceBlackOnTheChessboard)
			updateOfThePartsAttack = true
			
	elif turnWhite == false:
#		get_node("/root/ChessBoard/Camera2D").set_rotation_degrees(180)
		if updateOfThePartsAttack == true:
			updateAttackWhiteandBlack()
			attackPiecesWhite()
			attackPiecesBlack()
			enPassantFinish()
			verificationCheckAndCheckmate()
			verificationStalemate("White", "PawnBlack","KnightBlack","BishopBlack","RookBlack","QueenBlack",attackPieceWhiteOnTheChessboard)
			updateOfThePartsAttack = false

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
			chessBoard[i][j] = pieceBlack[j]
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
			chessBoard[i][j] = pieceWhite[j]
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
		attackPieceWhiteOnTheChessboard.append(row)
		
	for i in range(rowSize):
		var row = []
		for j in range(columnSize):
			row.append(null)
		attackPieceBlackOnTheChessboard.append(row)
	#	print(attackPieceWhiteOnTheChessboard)
	#	print(attackPieceBlackOnTheChessboard)

func initialisingAttackBoardWhiteAndBlack():
	for i in range(2,10): 
		for j in range(2,10):
			attackPieceWhiteOnTheChessboard[i][j] = 0
			attackPieceBlackOnTheChessboard[i][j] = 0

	for i in range(0,12):
		for j in range(0,12):
			if attackPieceWhiteOnTheChessboard[i][j] ==  null:
				attackPieceWhiteOnTheChessboard[i][j] = -9
	
	for i in range(0,12):
		for j in range(0,12):
			if attackPieceBlackOnTheChessboard[i][j] ==  null:
				attackPieceBlackOnTheChessboard[i][j] = -9
	
	printAttackWhite()
	printAttackBlack()

func updateAttackWhiteandBlack():
	for i in range(2,10): 
		for j in range(2,10):
			attackPieceWhiteOnTheChessboard[i][j] = 0
	for i in range(2,10): 
		for j in range(2,10):
			attackPieceBlackOnTheChessboard[i][j] = 0

func printAttackWhite():
	print("AttackBoardWhite: /AttackBoardBlack: ")
	for i in range(0,12):
		print(attackPieceWhiteOnTheChessboard[i],attackPieceBlackOnTheChessboard[i])

func printAttackBlack():
	print("AttackBoardBlack: /AttackBoardWhite: ")
	for i in range(0,12):
		print(attackPieceBlackOnTheChessboard[i],attackPieceWhiteOnTheChessboard[i])

func pawnAttackWhite(i, j, chessBoard, attackPieceWhiteOnTheChessboard):
	for dx in [-1, 1]:
		var x = i - 1
		var y = j + dx
		if x >= 0 and y >= 0 and x < 12 and y < 12 and chessBoard[x][y] != "x":
			attackPieceWhiteOnTheChessboard[x][y] += 1

func knightAttackWhite(i, j, chessBoard, attackPieceWhiteOnTheChessboard):
	var knightMoves = [
		Vector2(-2, -1), Vector2(-2, 1),
		Vector2(-1, 2), Vector2(1, 2),
		Vector2(2, -1), Vector2(2, 1),
		Vector2(-1, -2), Vector2(1, -2)]
		
	for move in knightMoves:
		var x = i + move.x
		var y = j + move.y
		if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
			attackPieceWhiteOnTheChessboard[x][y] += 1

func bishopAttackWhite(i, j, dx, dy, attackPieceWhiteOnTheChessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingBlack":
				if attackPieceWhiteOnTheChessboard[x + dx][y + dy] <= -1:
					attackPieceWhiteOnTheChessboard[x][y] += 1
					break
				else:
					attackPieceWhiteOnTheChessboard[x][y] += 1
					attackPieceWhiteOnTheChessboard[x + dx][y + dy] += 1
					break
			else:
				attackPieceWhiteOnTheChessboard[x][y] += 1
				break
		else:
			attackPieceWhiteOnTheChessboard[x][y] += 1

func rookAttackWhite(i, j, dx, dy, attackPieceWhiteOnTheChessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingBlack":
				if attackPieceWhiteOnTheChessboard[x + dx][y + dy] <= -1:
					attackPieceWhiteOnTheChessboard[x][y] += 1
					break
				else:
					attackPieceWhiteOnTheChessboard[x][y] += 1
					attackPieceWhiteOnTheChessboard[x + dx][y + dy] += 1
					break
			else:
				attackPieceWhiteOnTheChessboard[x][y] += 1
				break
		else:
			attackPieceWhiteOnTheChessboard[x][y] += 1

func queenAttackWhite(i, j, attackPieceWhiteOnTheChessboard):
	rookAttackWhite(i, j, -1, 0, attackPieceWhiteOnTheChessboard)  # Vers le haut
	rookAttackWhite(i, j, 1, 0, attackPieceWhiteOnTheChessboard)  # Vers le bas
	rookAttackWhite(i, j, 0, 1, attackPieceWhiteOnTheChessboard)  # Vers la droite
	rookAttackWhite(i, j, 0, -1, attackPieceWhiteOnTheChessboard)  # Vers la gauche
	bishopAttackWhite(i, j, -1, 1, attackPieceWhiteOnTheChessboard)  # En haut à droite
	bishopAttackWhite(i, j, -1, -1, attackPieceWhiteOnTheChessboard)  # En haut à gauche
	bishopAttackWhite(i, j, 1, 1, attackPieceWhiteOnTheChessboard)  # En bas à droite
	bishopAttackWhite(i, j, 1, -1, attackPieceWhiteOnTheChessboard)  # En bas à gauche

func kingAttackWhite(i, j, chessBoard, attackPieceWhiteOnTheChessboard):
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue  # Ignore la position actuelle du roi
			var x = i + dx
			var y = j + dy
				
			if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
				attackPieceWhiteOnTheChessboard[x][y] += 1

func pawnAttackBlack(i, j, chessBoard, attackPieceBlackOnTheChessboard):
	for dx in [-1, 1]:
		var x = i + 1
		var y = j + dx
		if x >= 0 and y >= 0 and x < 12 and y < 12 and chessBoard[x][y] != "x":
			attackPieceBlackOnTheChessboard[x][y] += 1

func knightAttackBlack(i, j, chessBoard, attackPieceBlackOnTheChessboard):
	var knightMoves = [
		Vector2(-2, -1), Vector2(-2, 1),
		Vector2(-1, 2), Vector2(1, 2),
		Vector2(2, -1), Vector2(2, 1),
		Vector2(-1, -2), Vector2(1, -2)]
		
	for move in knightMoves:
		var x = i + move.x
		var y = j + move.y
		if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
			attackPieceBlackOnTheChessboard[x][y] += 1

func bishopAttackBlack(i, j, dx, dy, attackPieceBlackOnTheChessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingWhite":
				if attackPieceBlackOnTheChessboard[x + dx][y + dy] <= -1:
					attackPieceBlackOnTheChessboard[x][y] += 1
					break
				else:
					attackPieceBlackOnTheChessboard[x][y] += 1
					attackPieceBlackOnTheChessboard[x + dx][y + dy] += 1
					break
			else:
				attackPieceBlackOnTheChessboard[x][y] += 1
				break
		else:
			attackPieceBlackOnTheChessboard[x][y] += 1

func rookAttackBlack(i, j, dx, dy, attackPieceBlackOnTheChessboard):
	for f in range(1, 9):
		var x = i + dx * f
		var y = j + dy * f
		
		if x < 0 || x >= 12 || y < 0 || y >= 12 || chessBoard[x][y] == "x":
			break
		elif chessBoard[x][y] != "0":
			if chessBoard[x][y] == "KingWhite":
				if attackPieceBlackOnTheChessboard[x + dx][y + dy] <= -1:
					attackPieceBlackOnTheChessboard[x][y] += 1
					break
				else:
					attackPieceBlackOnTheChessboard[x][y] += 1
					attackPieceBlackOnTheChessboard[x + dx][y + dy] += 1
					break
			else:
				attackPieceBlackOnTheChessboard[x][y] += 1
				break
		else:
			attackPieceBlackOnTheChessboard[x][y] += 1

func queenAttackBlack(i, j, attackPieceBlackOnTheChessboard):
	rookAttackBlack(i, j, -1, 0, attackPieceBlackOnTheChessboard)  # Vers le haut
	rookAttackBlack(i, j, 1, 0, attackPieceBlackOnTheChessboard)  # Vers le bas
	rookAttackBlack(i, j, 0, 1, attackPieceBlackOnTheChessboard)  # Vers la droite
	rookAttackBlack(i, j, 0, -1, attackPieceBlackOnTheChessboard)  # Vers la gauche
	bishopAttackBlack(i, j, -1, 1, attackPieceBlackOnTheChessboard)  # En haut à droite
	bishopAttackBlack(i, j, -1, -1, attackPieceBlackOnTheChessboard)  # En haut à gauche
	bishopAttackBlack(i, j, 1, 1, attackPieceBlackOnTheChessboard)  # En bas à droite
	bishopAttackBlack(i, j, 1, -1, attackPieceBlackOnTheChessboard)  # En bas à gauche

func kingAttackBlack(i, j, chessBoard, attackPieceBlackOnTheChessboard):
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue  # Ignore la position actuelle du roi
			var x = i + dx
			var y = j + dy
				
			if x >= 0 and x < 12 and y >= 0 and y < 12 and chessBoard[x][y] != "x":
				attackPieceBlackOnTheChessboard[x][y] += 1

func attackPiecesWhite():
	for i in range(12):
		for j in range(12):
			var piece = chessBoard[i][j]
			if piece.begins_with("PawnWhite"):
				pawnAttackWhite(i, j, chessBoard, attackPieceWhiteOnTheChessboard)
						
			if piece.begins_with("KnightWhite"):
				knightAttackWhite(i, j, chessBoard, attackPieceWhiteOnTheChessboard)
			
			if piece.begins_with("BishopWhite"):
				bishopAttackWhite(i, j, -1, 1, attackPieceWhiteOnTheChessboard)  # En haut à droite
				bishopAttackWhite(i, j, -1, -1, attackPieceWhiteOnTheChessboard)  # En haut à gauche
				bishopAttackWhite(i, j, 1, 1, attackPieceWhiteOnTheChessboard)  # En bas à droite
				bishopAttackWhite(i, j, 1, -1, attackPieceWhiteOnTheChessboard)  # En bas à gauche
				
			if piece.begins_with("RookWhite"):
				rookAttackWhite(i, j, -1, 0, attackPieceWhiteOnTheChessboard)  # Vers le haut
				rookAttackWhite(i, j, 1, 0, attackPieceWhiteOnTheChessboard)  # Vers le bas
				rookAttackWhite(i, j, 0, 1, attackPieceWhiteOnTheChessboard)  # Vers la droite
				rookAttackWhite(i, j, 0, -1, attackPieceWhiteOnTheChessboard)  # Vers la gauche
				
			if piece.begins_with("QueenWhite"):
				queenAttackWhite(i, j, attackPieceWhiteOnTheChessboard)
			
			if piece == "KingWhite":
				kingAttackWhite(i, j, chessBoard, attackPieceWhiteOnTheChessboard)
				
	printAttackWhite()

func attackPiecesBlack():
	for i in range(12):
		for j in range(12):
			var piece = chessBoard[i][j]
			if piece.begins_with("PawnBlack"):
				pawnAttackBlack(i, j, chessBoard, attackPieceBlackOnTheChessboard)
						
			if piece.begins_with("KnightBlack"):
				knightAttackBlack(i, j, chessBoard, attackPieceBlackOnTheChessboard)
			
			if piece.begins_with("BishopBlack"):
				bishopAttackBlack(i, j, -1, 1, attackPieceBlackOnTheChessboard)  # En haut à droite
				bishopAttackBlack(i, j, -1, -1, attackPieceBlackOnTheChessboard)  # En haut à gauche
				bishopAttackBlack(i, j, 1, 1, attackPieceBlackOnTheChessboard)  # En bas à droite
				bishopAttackBlack(i, j, 1, -1, attackPieceBlackOnTheChessboard)  # En bas à gauche
				
			if piece.begins_with("RookBlack"):
				rookAttackBlack(i, j, -1, 0, attackPieceBlackOnTheChessboard)  # Vers le haut
				rookAttackBlack(i, j, 1, 0, attackPieceBlackOnTheChessboard)  # Vers le bas
				rookAttackBlack(i, j, 0, 1, attackPieceBlackOnTheChessboard)  # Vers la droite
				rookAttackBlack(i, j, 0, -1, attackPieceBlackOnTheChessboard)  # Vers la gauche
				
			if piece.begins_with("QueenBlack"):
				queenAttackBlack(i, j, attackPieceBlackOnTheChessboard)
			
			if piece == "KingBlack":
				kingAttackBlack(i, j, chessBoard, attackPieceBlackOnTheChessboard)
					
	printAttackBlack()

func enPassantFinish():
	print("Enter in enPassantFinish")
	if get_node("/root/ChessBoard") != null:
		var numberOfChildren = get_node("/root/ChessBoard").get_child_count()
	
		for f in range(numberOfChildren):
			var piece = get_node("/root/ChessBoard").get_child(f)
			var pieceName = piece.get_name()
			if turnWhite == true:
				if pieceName.begins_with("PawnWhite"):
					piece.enPassant = false
			elif turnWhite == false:
				if pieceName.begins_with("PawnBlack"):
					piece.enPassant = false

func findAttackerDirectionRow(chessBoard,kingNode,piece1,piece2):
	var directions = ["Haut", "Bas", "Droite", "Gauche"]
	var i
	var j
	
	for direction in directions:
		for f in range(1, 9):
			if direction == "Haut":
				i = kingNode.i - f
				j = kingNode.j
			elif direction == "Bas":
				i = kingNode.i + f
				j = kingNode.j
			elif direction == "Droite":
				i = kingNode.i
				j = kingNode.j + f
			elif direction == "Gauche":
				i = kingNode.i
				j = kingNode.j - f
			
			if i < 0 or i >= 12 or j < 0 or j >= 12:
				break
			if chessBoard[i][j] == "x":
				break
			if chessBoard[i][j] != "0":
				var piece = chessBoard[i][j]
				if piece.begins_with(piece1) or piece.begins_with(piece2):
					attackerPositioni = i
					attackerPositionj = j
					directionOfAttack = direction
				else:
					break

func findAttackerDirectionDiagonal(chessBoard,kingNode,piece1,piece2):
	var directions = ["Haut/Droite", "Haut/Gauche", "Bas/Droite", "Bas/Gauche"]
	var i
	var j
	
	for direction in directions:
		for f in range(1, 9):
			if direction == "Haut/Droite":
				i = kingNode.i - f
				j = kingNode.j + f
			elif direction == "Haut/Gauche":
				i = kingNode.i - f
				j = kingNode.j - f
			elif direction == "Bas/Droite":
				i = kingNode.i + f
				j = kingNode.j + f
			elif direction == "Bas/Gauche":
				i = kingNode.i + f
				j = kingNode.j - f
			
			if i < 0 or i >= 12 or j < 0 or j >= 12:
				break
			if chessBoard[i][j] == "x":
				break
			if chessBoard[i][j] != "0":
				var piece = chessBoard[i][j]
				if piece.begins_with(piece1) or piece.begins_with(piece2):
					attackerPositioni = i
					attackerPositionj = j
					directionOfAttack = direction
				else:
					break

func findAttackerDirectionKnight(chessBoard,kingNode,piece):
	var knightMoves = [
		Vector2(-2, -1), Vector2(-2, 1),
		Vector2(-1, 2), Vector2(1, 2),
		Vector2(2, -1), Vector2(2, 1),
		Vector2(-1, -2), Vector2(1, -2)]

	for move in knightMoves:
		var dx = move[0]
		var dy = move[1]
		
		var targetI = kingNode.i + dx
		var targetJ = kingNode.j + dy

		if targetI >= 0 and targetI < 12 and targetJ >= 0 and targetJ < 12:
			var targetPiece = chessBoard[targetI][targetJ]

			if targetPiece != "x" and targetPiece.begins_with(piece):
				attackerPositioni = targetI
				attackerPositionj = targetJ
				directionOfAttack = "Cavalier"
				break

func findAttackerDirectionPawnWhite(chessBoard,kingNode):
	#Vers le bas à droite
		if chessBoard[kingNode.i+1][kingNode.j+1] == "x":
			pass
		elif chessBoard[kingNode.i+1][kingNode.j+1] != "0":
			
			if chessBoard[kingNode.i+1][kingNode.j+1].begins_with("PawnWhite"):
				attackerPositioni = kingNode.i+1
				attackerPositionj = kingNode.j+1
				directionOfAttack = "Bas/Droite"
				
		#Vers le bas à gauche
		if chessBoard[kingNode.i+1][kingNode.j-1] == "x":
			pass
		elif chessBoard[kingNode.i+1][kingNode.j-1] != "0":
			
			if chessBoard[kingNode.i+1][kingNode.j-1].begins_with("PawnWhite"):
				attackerPositioni = kingNode.i+1
				attackerPositionj = kingNode.j-1
				directionOfAttack = "Bas/Gauche"

func findAttackerDirectionPawnBlack(chessBoard,kingNode):
	#Vers le haut à droite
		if chessBoard[kingNode.i-1][kingNode.j+1] == "x":
			pass
		elif chessBoard[kingNode.i-1][kingNode.j+1] != "0":
			
			if chessBoard[kingNode.i-1][kingNode.j+1].begins_with("PawnBlack"):
				attackerPositioni = kingNode.i-1
				attackerPositionj = kingNode.j+1
				directionOfAttack = "Haut/Droite"
				
		#Vers le haut à gauche
		if chessBoard[kingNode.i-1][kingNode.j-1] == "x":
			pass
		elif chessBoard[kingNode.i-1][kingNode.j-1] != "0":
			
			if chessBoard[kingNode.i-1][kingNode.j-1].begins_with("PawnBlack"):
				attackerPositioni = kingNode.i-1
				attackerPositionj = kingNode.j-1
				directionOfAttack = "Haut/Gauche"

func checkingDirectionOfAttack(chessBoard,kingNode,knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier dans quelle direction vient l'attaque (référenciel du Roi)
	if kingColor == "KingBlack":
		findAttackerDirectionPawnBlack(chessBoard,kingNode)
	elif kingColor == "KingWhite":
		findAttackerDirectionPawnWhite(chessBoard,kingNode)
	findAttackerDirectionRow(chessBoard,kingNode,rookColor,queenColor)
	findAttackerDirectionDiagonal(chessBoard,kingNode,bishopColor,queenColor)
	findAttackerDirectionKnight(chessBoard,kingNode,knightColor)

func sendDefenceCoordinates(pathPiece,attackI,attackJ,targetPiece):
	print("Enter in sendDefenceCoordinates")
	if targetPiece.begins_with("Queen"):
		if pathPiece.attackerPositionshiftI == 0\
		and pathPiece.attackerPositionshiftJ == 0:
			pathPiece.attackerPositionshiftI = attackI
			pathPiece.attackerPositionshiftJ = attackJ
		elif pathPiece.attackerPositionshift2I == 0\
		and pathPiece.attackerPositionshift2J == 0:
			pathPiece.attackerPositionshift2I = attackI
			pathPiece.attackerPositionshift2J = attackJ
		elif pathPiece.attackerPositionshift3I == 0\
		and pathPiece.attackerPositionshift3J == 0:
			pathPiece.attackerPositionshift3I = attackI
			pathPiece.attackerPositionshift3J = attackJ
	else:
		if pathPiece.attackerPositionshiftI == 0\
		and pathPiece.attackerPositionshiftJ == 0:
			pathPiece.attackerPositionshiftI = attackI
			pathPiece.attackerPositionshiftJ = attackJ
		elif pathPiece.attackerPositionshift2I == 0\
		and pathPiece.attackerPositionshift2J == 0:
			pathPiece.attackerPositionshift2I = attackI
			pathPiece.attackerPositionshift2J = attackJ
	pathPiece.pieceProtectTheKing = true

func searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,piece1,piece2):
	print("Enter in searchDefenderRow")
	var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	
	for direction in directions:
		var dx = direction[0]
		var dy = direction[1]
		
		for ff in range(1,9):
			var targetI = attackerPositionILoop + ff * dx
			var targetJ = attackerPositionJLoop + ff * dy
			
			if targetI < 0 or targetI >= 12 or targetJ < 0 or targetJ >= 12:
				break
				
			var targetPiece = chessBoard[targetI][targetJ]
			
			if targetPiece == "x":
				break
			elif targetPiece != "0":
				print("targetPiece: ", targetPiece)
				if targetPiece.begins_with(piece1) or targetPiece.begins_with(piece2):
					var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
					pieceProtectTheKing = true
					sendDefenceCoordinates(pathPiece,attackerPositionILoop,attackerPositionJLoop,targetPiece)
					print("pieceProtectTheKing: ", pieceProtectTheKing)
					break
				else:
					break

func searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,piece1,piece2):
	print("Enter in searchDefenderDiagonal")
	var directions = [Vector2(1, 1), Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1)]
	
	for direction in directions:
		var dx = direction[0]
		var dy = direction[1]
		
		for ff in range(1,9):
			var targetI = attackerPositionILoop + ff * dx
			var targetJ = attackerPositionJLoop + ff * dy
			
			if targetI < 0 or targetI >= 12 or targetJ < 0 or targetJ >= 12:
				break
				
			var targetPiece = chessBoard[targetI][targetJ]
			
			if targetPiece == "x":
				break
			elif targetPiece != "0":
				print("targetPiece: ", targetPiece)
				if targetPiece.begins_with(piece1) or targetPiece.begins_with(piece2):
					var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
					pieceProtectTheKing = true
					sendDefenceCoordinates(pathPiece,attackerPositionILoop,attackerPositionJLoop,targetPiece)
					print("pieceProtectTheKing: ", pieceProtectTheKing)
					break
				else:
					break

func searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,piece):
	print("Enter in searchDefenderKnight")
	var directions = [
		Vector2(-2, -1), Vector2(-2, 1),
		Vector2(-1, 2), Vector2(1, 2),
		Vector2(2, -1), Vector2(2, 1),
		Vector2(-1, -2), Vector2(1, -2)]
	
	for direction in directions:
		var dx = direction[0]
		var dy = direction[1]
		
		var targetI = attackerPositionILoop + dx
		var targetJ = attackerPositionJLoop + dy
			
		var targetPiece = chessBoard[targetI][targetJ]
		
		if targetPiece == "x":
			continue
		elif targetPiece != "0":
			print("targetPiece: ", targetPiece)
			if targetPiece.begins_with(piece):
				var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
				pieceProtectTheKing = true
				sendDefenceCoordinates(pathPiece,attackerPositionILoop,attackerPositionJLoop,targetPiece)
				print("pieceProtectTheKing: ", pieceProtectTheKing)

func searchDefenderPawnWhiteRow(attackerPositionILoop,attackerPositionJLoop):
	print("Enter in searchDefenderPawnWhiteRow")
	#vers le bas de 1
	print("ffpwb: ",chessBoard[attackerPositionILoop+1][attackerPositionJLoop])
	if chessBoard[attackerPositionILoop+1][attackerPositionJLoop] == "x":
		pass
	elif chessBoard[attackerPositionILoop+1][attackerPositionJLoop] != "0":
		print("ffpwb: ",chessBoard[attackerPositionILoop+1][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop+1][attackerPositionJLoop].begins_with("PawnWhite"):
			var targetPiece = chessBoard[attackerPositionILoop+1][attackerPositionJLoop]
			var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
			pieceProtectTheKing = true
			sendDefenceCoordinates(pathPiece,attackerPositionILoop,attackerPositionJLoop,targetPiece)
			print("pieceProtectTheKing: ", pieceProtectTheKing)
			
	#vers le bas de 2 si initialPosition == true
	print("ffpwb: ",chessBoard[attackerPositionILoop+2][attackerPositionJLoop])
	if chessBoard[attackerPositionILoop+2][attackerPositionJLoop] == "x":
		pass
	elif chessBoard[attackerPositionILoop+2][attackerPositionJLoop] != "0":
		var pawnName = chessBoard[attackerPositionILoop+2][attackerPositionJLoop]
		print("ffpwb: ",chessBoard[attackerPositionILoop+2][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop+2][attackerPositionJLoop].begins_with("PawnWhite")\
		and get_node("/root/ChessBoard/" + pawnName).initialPosition == true:
			var targetPiece = chessBoard[attackerPositionILoop+2][attackerPositionJLoop]
			var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
			pieceProtectTheKing = true
			sendDefenceCoordinates(pathPiece,attackerPositionILoop,attackerPositionJLoop,targetPiece)
			print("pieceProtectTheKing: ", pieceProtectTheKing)

func searchDefenderPawnBlackRow(attackerPositionILoop,attackerPositionJLoop):
	print("Enter in searchDefenderPawnBlackRow")
	#vers le haut de 1
	print("ffpbb: ",chessBoard[attackerPositionILoop-1][attackerPositionJLoop])
	if chessBoard[attackerPositionILoop-1][attackerPositionJLoop] == "x":
		pass
	elif chessBoard[attackerPositionILoop-1][attackerPositionJLoop] != "0":
		print("ffpbb: ",chessBoard[attackerPositionILoop-1][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop-1][attackerPositionJLoop].begins_with("PawnBlack"):
			var targetPiece = chessBoard[attackerPositionILoop-1][attackerPositionJLoop]
			var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
			pieceProtectTheKing = true
			sendDefenceCoordinates(pathPiece,attackerPositionILoop,attackerPositionJLoop,targetPiece)
			print("pieceProtectTheKing: ", pieceProtectTheKing)
			
	#vers le haut de 2 si initialPosition == true
	print("ffpbb: ",chessBoard[attackerPositionILoop-2][attackerPositionJLoop])
	if chessBoard[attackerPositionILoop-2][attackerPositionJLoop] == "x":
		pass
	elif chessBoard[attackerPositionILoop-2][attackerPositionJLoop] != "0":
		var pawnName = chessBoard[attackerPositionILoop-2][attackerPositionJLoop]
		print("ffpbb: ",chessBoard[attackerPositionILoop-2][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop-2][attackerPositionJLoop].begins_with("PawnBlack")\
		and get_node("/root/ChessBoard/" + pawnName).initialPosition == true:
			var targetPiece = chessBoard[attackerPositionILoop-2][attackerPositionJLoop]
			var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
			pieceProtectTheKing = true
			sendDefenceCoordinates(pathPiece,attackerPositionILoop,attackerPositionJLoop,targetPiece)
			print("pieceProtectTheKing: ", pieceProtectTheKing)

func searchDefenderPawnWhiteDiagonal(attack1, attack2):
	print("Enter in searchDefenderPawnWhiteDiagonal")
	if attack1 == true:
	#Vers le bas à droite
		print("ffpwd: ",chessBoard[attackerPositioni+1][attackerPositionj+1])
		if chessBoard[attackerPositioni+1][attackerPositionj+1] == "x":
			pass
		elif chessBoard[attackerPositioni+1][attackerPositionj+1] != "0":
			print("ffpwd: ",chessBoard[attackerPositioni+1][attackerPositionj+1])
			if chessBoard[attackerPositioni+1][attackerPositionj+1].begins_with("PawnWhite"):
				var targetPiece = chessBoard[attackerPositioni+1][attackerPositionj+1]
				var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
				pieceProtectTheKing = true
				sendDefenceCoordinates(pathPiece,attackerPositioni,attackerPositionj,targetPiece)
				print("pieceProtectTheKing: ", pieceProtectTheKing)
				
	if attack2 == true:
		#Vers le bas à gauche
		print("ffpwg: ",chessBoard[attackerPositioni+1][attackerPositionj-1])
		if chessBoard[attackerPositioni+1][attackerPositionj-1] == "x":
			pass
		elif chessBoard[attackerPositioni+1][attackerPositionj-1] != "0":
			print("ffpwg: ",chessBoard[attackerPositioni+1][attackerPositionj-1])
			if chessBoard[attackerPositioni+1][attackerPositionj-1].begins_with("PawnWhite"):
				var targetPiece = chessBoard[attackerPositioni+1][attackerPositionj-1]
				var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
				pieceProtectTheKing = true
				sendDefenceCoordinates(pathPiece,attackerPositioni,attackerPositionj,targetPiece)
				print("pieceProtectTheKing: ", pieceProtectTheKing)

func searchDefenderPawnBlackDiagonal(attack1, attack2):
	print("Enter in searchDefenderPawnBlack")
	if attack1 == true:
	#Vers le haut à droite
		print("ffpbd: ",chessBoard[attackerPositioni-1][attackerPositionj+1])
		if chessBoard[attackerPositioni-1][attackerPositionj+1] == "x":
			pass
		elif chessBoard[attackerPositioni-1][attackerPositionj+1] != "0":
			print("ffpbd: ",chessBoard[attackerPositioni-1][attackerPositionj+1])
			if chessBoard[attackerPositioni-1][attackerPositionj+1].begins_with("PawnBlack"):
				var targetPiece = chessBoard[attackerPositioni-1][attackerPositionj+1]
				var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
				pieceProtectTheKing = true
				sendDefenceCoordinates(pathPiece,attackerPositioni,attackerPositionj,targetPiece)
				print("pieceProtectTheKing: ", pieceProtectTheKing)
				
	if attack2 == true:
		#Vers le haut à gauche
		print("ffpbg: ",chessBoard[attackerPositioni-1][attackerPositionj-1])
		if chessBoard[attackerPositioni-1][attackerPositionj-1] == "x":
			pass
		elif chessBoard[attackerPositioni-1][attackerPositionj-1] != "0":
			print("ffpbg: ",chessBoard[attackerPositioni-1][attackerPositionj-1])
			if chessBoard[attackerPositioni-1][attackerPositionj-1].begins_with("PawnBlack"):
				var targetPiece = chessBoard[attackerPositioni-1][attackerPositionj-1]
				var pathPiece = get_node("/root/ChessBoard/" + targetPiece)
				pieceProtectTheKing = true
				sendDefenceCoordinates(pathPiece,attackerPositioni,attackerPositionj,targetPiece)
				print("pieceProtectTheKing: ", pieceProtectTheKing)

func attackComingUp(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du haut, on descend chaque case jusqu'au roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhiteDiagonal(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlackDiagonal(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni + f
		var attackerPositionJLoop = attackerPositionj
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingDown(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du bas, on monte chaque case jusqu'au roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhiteDiagonal(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlackDiagonal(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni - f
		var attackerPositionJLoop = attackerPositionj
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingRight(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant de la droite, on va vers la gauche pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhiteDiagonal(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlackDiagonal(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni
		var attackerPositionJLoop = attackerPositionj - f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			if kingColor == "KingWhite" and f != 0:
				searchDefenderPawnWhiteRow(attackerPositionILoop,attackerPositionJLoop)
			elif kingColor == "KingBlack" and f != 0:
				searchDefenderPawnBlackRow(attackerPositionILoop,attackerPositionJLoop)
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingLeft(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant de la gauche, on va vers la droite pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhiteDiagonal(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlackDiagonal(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni
		var attackerPositionJLoop = attackerPositionj + f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			if kingColor == "KingWhite" and f != 0:
				searchDefenderPawnWhiteRow(attackerPositionILoop,attackerPositionJLoop)
			elif kingColor == "KingBlack" and f != 0:
				searchDefenderPawnBlackRow(attackerPositionILoop,attackerPositionJLoop)
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingUpRight(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du haut à droite, on va vers bas à gauche pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhiteDiagonal(true,false)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlackDiagonal(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni + f
		var attackerPositionJLoop = attackerPositionj - f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			if kingColor == "KingWhite" and f != 0:
				searchDefenderPawnWhiteRow(attackerPositionILoop,attackerPositionJLoop)
			elif kingColor == "KingBlack" and f != 0:
				searchDefenderPawnBlackRow(attackerPositionILoop,attackerPositionJLoop)
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingUpLeft(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du haut à gauche, on va vers bas à droite pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhiteDiagonal(false,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlackDiagonal(true,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni + f
		var attackerPositionJLoop = attackerPositionj + f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			if kingColor == "KingWhite" and f != 0:
				searchDefenderPawnWhiteRow(attackerPositionILoop,attackerPositionJLoop)
			elif kingColor == "KingBlack" and f != 0:
				searchDefenderPawnBlackRow(attackerPositionILoop,attackerPositionJLoop)
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingDownRight(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du bas à droite, on va vers haut à gauche pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhiteDiagonal(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlackDiagonal(true,false)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni - f
		var attackerPositionJLoop = attackerPositionj - f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			if kingColor == "KingWhite" and f != 0:
				searchDefenderPawnWhiteRow(attackerPositionILoop,attackerPositionJLoop)
			elif kingColor == "KingBlack" and f != 0:
				searchDefenderPawnBlackRow(attackerPositionILoop,attackerPositionJLoop)
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingDownLeft(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du bas à gauche, on va vers haut à droite pour trouver le roi
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhiteDiagonal(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlackDiagonal(false,true)
	#Lignes et cavaliers
	for f in range(9):
		var attackerPositionILoop = attackerPositioni - f
		var attackerPositionJLoop = attackerPositionj + f
		print("attackerPositionILoop: ",attackerPositionILoop)
		print("attackerPositionJLoop: ",attackerPositionJLoop)
		print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
		if chessBoard[attackerPositionILoop][attackerPositionJLoop] != kingColor:
			if kingColor == "KingWhite" and f != 0:
				searchDefenderPawnWhiteRow(attackerPositionILoop,attackerPositionJLoop)
			elif kingColor == "KingBlack" and f != 0:
				searchDefenderPawnBlackRow(attackerPositionILoop,attackerPositionJLoop)
			searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
			searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
			searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)
		else:
			break

func attackComingKnight(knightColor,bishopColor,rookColor,queenColor,kingColor):
	#Vérifier quelle pièce peut protéger le roi
	#Pour une attaque venant du cavalier, on cherche qui peut le prendre
	#Pawns
	if kingColor == "KingWhite":
		searchDefenderPawnWhiteDiagonal(true,true)
	elif kingColor == "KingBlack":
		searchDefenderPawnBlackDiagonal(true,true)
	#Lignes et cavaliers
	var attackerPositionILoop = attackerPositioni
	var attackerPositionJLoop = attackerPositionj
	print("attackerPositionILoop: ",attackerPositionILoop)
	print("attackerPositionJLoop: ",attackerPositionJLoop)
	print("piece name: ", chessBoard[attackerPositionILoop][attackerPositionJLoop])
	searchDefenderRow(attackerPositionILoop,attackerPositionJLoop,rookColor,queenColor)
	searchDefenderDiagonal(attackerPositionILoop,attackerPositionJLoop,bishopColor,queenColor)
	searchDefenderKnight(attackerPositionILoop,attackerPositionJLoop,knightColor)

func verificationDefenderAllAttack(knightColor,bishopColor,rookColor,queenColor,kingColor):
	if directionOfAttack == "Haut":
		print("Enter AttackCommingUp")
		attackComingUp(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Bas":
		print("Enter AttackCommingDown")
		attackComingDown(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Droite":
		print("Enter AttackCommingRight")
		attackComingRight(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Gauche":
		print("Enter AttackCommingLeft")
		attackComingLeft(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Haut/Droite":
		print("Enter AttackCommingUpRight")
		attackComingUpRight(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Haut/Gauche":
		print("Enter AttackCommingUpLeft")
		attackComingUpLeft(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Bas/Droite":
		print("Enter AttackCommingDownRight")
		attackComingDownRight(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Bas/Gauche":
		print("Enter AttackCommingDownLeft")
		attackComingDownLeft(knightColor,bishopColor,rookColor,queenColor,kingColor)
	elif directionOfAttack == "Cavalier":
		print("Enter AttackCommingKnight")
		attackComingKnight(knightColor,bishopColor,rookColor,queenColor,kingColor)

func checkmateKing(pawnColor,knightColor,bishopColor,rookColor,queenColor,kingNode,attackColor):
	#On verifie l'échec et mat si aucune pièce ne peut protèger le roi
	if not pieceProtectTheKing:
		
		for i in range(kingNode.i - 1, kingNode.i + 2):
			for j in range(kingNode.j - 1, kingNode.j + 2):
				if i != kingNode.i or j != kingNode.j:
					if (i >= 0 and i < 12 and j >= 0 and j < 12
						and (attackColor[i][j] >= 1 or attackColor[i][j] <= -1
						or chessBoard[i][j].begins_with(pawnColor) or chessBoard[i][j].begins_with(knightColor)
						or chessBoard[i][j].begins_with(bishopColor) or chessBoard[i][j].begins_with(rookColor)
						or chessBoard[i][j].begins_with(queenColor))):
						threatened = true
						break

func stalemateOnlyKing():
	var pieceFinded = false
	for i in range(2,10): 
		for j in range(2,10):
			if chessBoard[i][j].begins_with("PawnWhite") or chessBoard[i][j].begins_with("KnightWhite")\
			or chessBoard[i][j].begins_with("BishopWhite") or chessBoard[i][j].begins_with("RookWhite")\
			or chessBoard[i][j].begins_with("QueenWhite") or chessBoard[i][j].begins_with("PawnBlack")\
			or chessBoard[i][j].begins_with("KnightBlack") or chessBoard[i][j].begins_with("BishopBlack")\
			or chessBoard[i][j].begins_with("RookBlack") or chessBoard[i][j].begins_with("QueenBlack"):
				stalemate = false
				pieceFinded = true
				break
			else:
				stalemate = true
		if pieceFinded == true:
			break
	print("stalemateOnlyKing: ", stalemate)

func verificationStalemate(color,pawnColor,knightColor,bishopColor,rookColor,queenColor,attackColor):
	var KingWhite = get_node("/root/ChessBoard/KingWhite")
	var KingBlack = get_node("/root/ChessBoard/KingBlack")
	var pieceFinded1 = false
	var pieceFinded2 = false
	var onlyPawnAndKing = false
	var pawnMove = true
	print("Enter in verificationStalemate")
	
	stalemateOnlyKing()
	
	for i in range(2,10): 
		for j in range(2,10):
			if chessBoard[i][j].begins_with(knightColor) or chessBoard[i][j].begins_with(bishopColor)\
			or chessBoard[i][j].begins_with(rookColor) or chessBoard[i][j].begins_with(queenColor):
				onlyPawnAndKing = false
				pieceFinded1 = true
				break
			else:
				onlyPawnAndKing = true
		if pieceFinded1 == true:
			break
	print("onlyPawnAndKing: ", onlyPawnAndKing)

	if onlyPawnAndKing == true:
		for i in range(2,10): 
			for j in range(2,10):
				if chessBoard[i][j].begins_with(pawnColor):
					if "White" in chessBoard[i][j]:
						if chessBoard[i-1][j] == "0" or color in chessBoard[i-1][j+1]\
						or color in chessBoard[i-1][j-1]:
							pawnMove = true
							pieceFinded2 = true
							break
						else:
							pawnMove = false
							
					elif "Black" in chessBoard[i][j]:
						if chessBoard[i+1][j] == "0" or color in chessBoard[i+1][j+1]\
						or color in chessBoard[i+1][j-1]:
							pawnMove = true
							pieceFinded2 = true
							break
						else:
							pawnMove = false
			if pieceFinded2 == true:
				break
		print("pawnMove: ", pawnMove)
	
	if pawnMove == false:
		if color == "Black":
			if attackColor[KingWhite.i][KingWhite.j] == 0:
				if attackColor[KingWhite.i-1][KingWhite.j] <= 1\
				and attackColor[KingWhite.i-1][KingWhite.j+1] <= 1\
				and attackColor[KingWhite.i][KingWhite.j+1] <= 1\
				and attackColor[KingWhite.i+1][KingWhite.j+1] <= 1\
				and attackColor[KingWhite.i+1][KingWhite.j] <= 1\
				and attackColor[KingWhite.i+1][KingWhite.j-1] <= 1\
				and attackColor[KingWhite.i][KingWhite.j-1] <= 1\
				and attackColor[KingWhite.i-1][KingWhite.j-1] <= 1:
					stalemate = true
			else:
				stalemate = false
				
		if color == "White":
			if attackColor[KingBlack.i][KingBlack.j] == 0:
				if attackColor[KingBlack.i-1][KingBlack.j] <= 1\
				and attackColor[KingBlack.i-1][KingBlack.j+1] <= 1\
				and attackColor[KingBlack.i][KingBlack.j+1] <= 1\
				and attackColor[KingBlack.i+1][KingBlack.j+1] <= 1\
				and attackColor[KingBlack.i+1][KingBlack.j] <= 1\
				and attackColor[KingBlack.i+1][KingBlack.j-1] <= 1\
				and attackColor[KingBlack.i][KingBlack.j-1] <= 1\
				and attackColor[KingBlack.i-1][KingBlack.j-1] <= 1:
					stalemate = true
			else:
				stalemate = false
		print("stalemate: ", stalemate)

func verificationCheckAndCheckmate():
	if get_node("/root/ChessBoard/KingWhite") != null:
		var KingWhite = get_node("/root/ChessBoard/KingWhite")
		var KingBlack = get_node("/root/ChessBoard/KingBlack")
		
		print("Enter in verificationCheckAndCheckmate")
		if turnWhite == true:
			if attackPieceWhiteOnTheChessboard[KingBlack.i][KingBlack.j] == 0:
				checkBlack = false
				pieceProtectTheKing = false
			if attackPieceBlackOnTheChessboard[KingWhite.i][KingWhite.j] >= 1:
				checkWhite = true
				
				checkingDirectionOfAttack(chessBoard,KingWhite,"KnightBlack","BishopBlack","RookBlack","QueenBlack","KingBlack")
				print("directionOfAttack: ",directionOfAttack)
				
				verificationDefenderAllAttack("KnightWhite","BishopWhite","RookWhite","QueenWhite","KingWhite")
				
				checkmateKing("PawnWhite","KnightWhite","BishopWhite","RookWhite","QueenWhite",KingWhite,attackPieceBlackOnTheChessboard)
				
				if threatened == true:
					checkmate = true
					print("Echec et mat pour le roi blanc")
				
			print("King White check: ", checkWhite)
			print("King Black check: ", checkBlack)
			
		else:
			if attackPieceBlackOnTheChessboard[KingWhite.i][KingWhite.j] == 0:
				checkWhite = false
				pieceProtectTheKing = false
			if attackPieceWhiteOnTheChessboard[KingBlack.i][KingBlack.j] >= 1:
				checkBlack = true
				
				checkingDirectionOfAttack(chessBoard,KingBlack,"KnightWhite","BishopWhite","RookWhite","QueenWhite","KingWhite")
				print("directionOfAttack: ",directionOfAttack)
				
				verificationDefenderAllAttack("KnightBlack","BishopBlack","RookBlack","QueenBlack","KingBlack")
				
				checkmateKing("PawnBlack","KnightBlack","BishopBlack","RookBlack","QueenBlack",KingBlack,attackPieceWhiteOnTheChessboard)
				
				if threatened == true:
					checkmate = true
					print("Echec et mat pour le roi noir")
				
			print("King White check: ", checkWhite)
			print("King Black check: ", checkBlack)
