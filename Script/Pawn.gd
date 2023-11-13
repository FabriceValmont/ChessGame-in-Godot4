extends Sprite2D

signal promotionTurn

var dragging = false
var clickRadius = 50
var dragOffset = Vector2()
var moveCase = VariableGlobal.oneMoveCase
var chessBoard = VariableGlobal.chessBoard
var i = 8
var j = 2
var positionChessBoard
var Position = Vector2(50, 650)
@onready var nameOfPiece = get_name()
var initialPosition = true
var white = true
var textureWhite = preload("res://Sprite/Piece/White/pawn_white.png")
var textureBlack = preload("res://Sprite/Piece/Black/pawn_black.png")
var pieceProtectsAgainstAnAttack = false
var directionAttackProtectKing = ""
var promoteInProgress = false
var enPassant = false
var pieceProtectTheKing = false
var attackerPositionshiftI = 0
var attackerPositionshiftJ = 0
var attackerPositionshift2I = 0
var attackerPositionshift2J = 0

func _ready():  
	await get_tree().process_frame
	positionChessBoard = get_parent().global_position
	if VariableGlobalOption.modeEditor == false:
		if VariableGlobal.startWhite == true:
			playWhite()
		elif VariableGlobal.startWhite == false:
			playBlack()
	elif VariableGlobalOption.modeEditor == true:
		if white == true:
			texture = textureWhite
			playModeEditor("White")
		elif white == false:
			texture = textureBlack
			playModeEditor("Black")
		print(nameOfPiece, " i: ", i, " j: ", j, " PositionX: ", Position.x, " PositionY: ", Position.y )
		for f in range(0,12):
			print(chessBoard[f])

func _process(delta):
	pass

func _input(event):
	#J'ai un problème quand je met le bouton MOUSE_BUTTON_LEFT 2 fois dans deux if différent.
	#J'ai donc mit le MOUSE_BUTTON_RIGHT pour la promotion
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if VariableGlobal.startWhite == true:
			if promoteInProgress == true and VariableGlobal.turnWhite == true and i == 2:
				promotionSelectionWhite()
			elif promoteInProgress == true and VariableGlobal.turnWhite == false and i == 9:
				promotionSelectionBlack()
		elif VariableGlobal.startWhite == false:
			if promoteInProgress == true and VariableGlobal.turnWhite == true and i == 9:
				promotionSelectionWhite()
			elif promoteInProgress == true and VariableGlobal.turnWhite == false and i == 2:
				promotionSelectionBlack()
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT\
	and promoteInProgress == false and VariableGlobal.checkmate == false and VariableGlobal.stalemate == false:
		if (event.position - self.position - positionChessBoard).length() < clickRadius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
				dragOffset = event.position - self.position - positionChessBoard
				z_index = 10
				theKingIsBehind()
				previewAllMove()
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			deleteAllChildMovePreview()
			get_node("Area2D/CollisionShape2D").disabled = false
			if white == true and VariableGlobal.turnWhite == true:
				moveFinal(VariableGlobal.checkWhite)
			elif white == false and VariableGlobal.turnWhite == false:
				moveFinal(VariableGlobal.checkBlack)
			self.position = Vector2(Position.x, Position.y)
			dragging = false
			z_index = 0
			for f in range(0,12):
				print(chessBoard[f])
				
	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position - positionChessBoard
		get_node("Area2D/CollisionShape2D").disabled = true
		
func move(dx, dy) :
	for f in range (1,2):
		var targetCaseX = dx*(f*moveCase)
		var targetCaseY = dy*(f*moveCase)
		var newTargetCaseX = targetCaseX + positionChessBoard.x
		var newTargetCaseY = targetCaseY + positionChessBoard.y
		if global_position.x >= (Position.x - 50) + newTargetCaseX  and global_position.x <= (Position.x + 50) + newTargetCaseX \
		and global_position.y >= (Position.y - 50) + newTargetCaseY and global_position.y <= (Position.y + 50) + newTargetCaseY \
		and ((chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "Black" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == true\
		and (chessBoard[i+(dy*f)][j] == "0" or chessBoard[i+(dy*f)][j] != "0")\
		or (chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "White" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == false\
		and (chessBoard[i+(dy*f)][j] == "0" or chessBoard[i+(dy*f)][j] != "0")):
			self.position = Vector2((Position.x + targetCaseX), (Position.y + targetCaseY))
			Position = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i+(dy*f)
			j=j+(dx*f)
			chessBoard[i][j] = nameOfPiece.replace("@", "")
			if VariableGlobal.startWhite == true:
				if chessBoard[i][j].begins_with("PawnWhite") and i == 2:
					promotion("White","knight_white", "bishop_white", "rook_white", "queen_white")
				elif chessBoard[i][j].begins_with("PawnBlack") and i == 9:
					promotion("Black","knight_black", "bishop_black", "rook_black", "queen_black")
			elif VariableGlobal.startWhite == false:
				if chessBoard[i][j].begins_with("PawnWhite") and i == 9:
					promotion("White","knight_white", "bishop_white", "rook_white", "queen_white")
				elif chessBoard[i][j].begins_with("PawnBlack") and i == 2:
					promotion("Black","knight_black", "bishop_black", "rook_black", "queen_black")
			if promoteInProgress == false:
				VariableGlobal.turnWhite = !VariableGlobal.turnWhite
			initialPosition = false
			get_node("SoundMovePiece").play()
			resetLastMovePlay()
			lastMovePlay()
			break
		elif global_position.x >= get_parent().texture.get_width() + positionChessBoard.x\
		 or global_position.y >= get_parent().texture.get_height() + positionChessBoard.y :
			self.position = Vector2(Position.x, Position.y)
			
func moveWithPinWhite(dx,dy,enPassantI):
	if pieceProtectsAgainstAnAttack == false:
		if initialPosition == true:
			if chessBoard[i+dy][j] == "0":
				move(0,dy)
			if chessBoard[i+dy*2][j] == "0":
				move(0,dy*2)
			if chessBoard[i+dy][j-dx] != "0":
				move(-dx,dy)
			if chessBoard[i+dy][j+dx] != "0":
				move(dx,dy)
			enPassant = true
		else :
			if i == enPassantI and chessBoard[i][j-dx].begins_with("PawnBlack")\
			and get_node("/root/gameScreen/ChessBoard/" + chessBoard[i][j-dx]).enPassant == true:
				get_node("/root/gameScreen/ChessBoard/" + chessBoard[i][j-dx]).queue_free()
				chessBoard[i][j-dx] = "0"
				move(-dx,dy)
			if i == enPassantI and chessBoard[i][j+dx].begins_with("PawnBlack")\
			and get_node("/root/gameScreen/ChessBoard/" + chessBoard[i][j+dx]).enPassant == true:
				get_node("/root/gameScreen/ChessBoard/" + chessBoard[i][j+dx]).queue_free()
				chessBoard[i][j+dx] = "0"
				move(dx,dy)
			if chessBoard[i+dy][j] == "0":
				move(0,dy)
			if chessBoard[i+dy][j-dx] != "0":
				move(-dx,dy)
			if chessBoard[i+dy][j+dx] != "0":
				move(dx,dy)
			enPassant = false
	elif pieceProtectsAgainstAnAttack == true:
		if initialPosition == true:
			if directionAttackProtectKing == "Haut":
				if chessBoard[i+dy][j] == "0":
					move(0,dy)
				if chessBoard[i+dy*2][j] == "0":
					move(0,dy*2)
			elif directionAttackProtectKing == "Haut/Gauche":
				if chessBoard[i+dy][j-dx] != "0":
					move(-dx,dy)
			elif directionAttackProtectKing == "Haut/Droite":
				if chessBoard[i+dy][j+dx] != "0":
					move(dx,dy)
			enPassant = true
		else :
			if directionAttackProtectKing == "Haut":
				if chessBoard[i+dy][j] == "0":
					move(0,dy)
			elif directionAttackProtectKing == "Haut/Gauche":
				if chessBoard[i+dy][j-dx] != "0":
					move(-dx,dy)
			elif directionAttackProtectKing == "Haut/Droite":
				if chessBoard[i+dy][j+dx] != "0":
					move(dx,dy)
			enPassant = false

func moveWithPinBlack(dx,dy,enPassantI):
	if pieceProtectsAgainstAnAttack == false:
		if initialPosition == true:
			if chessBoard[i+dy][j] == "0":
				move(0,dy)
			if chessBoard[i+dy*2][j] == "0":
				move(0,dy*2)
			if chessBoard[i+dy][j-dx] != "0":
				move(-dx,dy)
			if chessBoard[i+dy][j+dx] != "0":
				move(dx,dy)
			enPassant = true
		else :
			if i == enPassantI and chessBoard[i][j-1].begins_with("PawnWhite")\
			and get_node("/root/gameScreen/ChessBoard/" + chessBoard[i][j-dx]).enPassant == true:
				get_node("/root/gameScreen/ChessBoard/" + chessBoard[i][j-dx]).queue_free()
				chessBoard[i][j-dx] = "0"
				move(-dx,dy)
			if i == enPassantI and chessBoard[i][j+1].begins_with("PawnWhite")\
			and get_node("/root/gameScreen/ChessBoard/" + chessBoard[i][j+dx]).enPassant == true:
				get_node("/root/gameScreen/ChessBoard/" + chessBoard[i][j+dx]).queue_free()
				chessBoard[i][j+dx] = "0"
				move(dx,dy)
			if chessBoard[i+dy][j] == "0":
				move(0,dy)
			if chessBoard[i+dy][j-dx] != "0":
				move(-dx,dy)
			if chessBoard[i+dy][j+dx] != "0":
				move(dx,dy)
			enPassant = false
	elif pieceProtectsAgainstAnAttack == true:
		if initialPosition == true:
			if directionAttackProtectKing == "Bas":
				if chessBoard[i+dy][j] == "0":
					move(0,dy)
				if chessBoard[i+dy*2][j] == "0":
					move(0,dy*2)
			elif directionAttackProtectKing == "Bas/Gauche":
				if chessBoard[i+dy][j-dx] != "0":
					move(-dx,dy)
			elif directionAttackProtectKing == "Bas/Droite":
				if chessBoard[i+dy][j+dx] != "0":
					move(dx,dy)
			enPassant = true
		else :
			if directionAttackProtectKing == "Bas":
				if chessBoard[i+dy][j] == "0":
					move(0,dy)
			elif directionAttackProtectKing == "Bas/Gauche":
				if chessBoard[i+dy][j-dx] != "0":
					move(-dx,dy)
			elif directionAttackProtectKing == "Bas/Droite":
				if chessBoard[i+dy][j+dx] != "0":
					move(dx,dy)
			enPassant = false

func defenceMove(attacki,attackj):
	print("Enter in defenceMove")
	var targetCaseX = (attackj - j) * moveCase
	var targetCaseY = (attacki - i) * moveCase
	var newTargetCaseX = targetCaseX + positionChessBoard.x
	var newTargetCaseY = targetCaseY + positionChessBoard.y
	if global_position.x >= (Position.x - 50) + newTargetCaseX  and global_position.x <= (Position.x + 50) + newTargetCaseX \
	and global_position.y >= (Position.y - 50) + newTargetCaseY and global_position.y <= (Position.y + 50) + newTargetCaseY \
	and ((chessBoard[attacki][attackj] == "0" or "Black" in chessBoard[attacki][attackj]) and VariableGlobal.turnWhite == true\
	or (chessBoard[attacki][attackj] == "0" or "White" in chessBoard[attacki][attackj]) and VariableGlobal.turnWhite == false):
		self.position = Vector2((Position.x + targetCaseX), (Position.y + targetCaseY))
		Position = Vector2(self.position.x, self.position.y)
		chessBoard[i][j] = "0"
		i=attacki
		j=attackj
		chessBoard[i][j] = nameOfPiece.replace("@", "")
		if chessBoard[i][j].begins_with("PawnWhite") and i == 2:
			promotion("White","knight_white", "bishop_white", "rook_white", "queen_white")
		elif chessBoard[i][j].begins_with("PawnBlack") and i == 9:
			promotion("Black","knight_black", "bishop_black", "rook_black", "queen_black")
		if promoteInProgress == false:
			VariableGlobal.turnWhite = !VariableGlobal.turnWhite
		initialPosition = false
		attackerPositionshiftI = 0
		attackerPositionshiftJ = 0
		attackerPositionshift2I = 0
		attackerPositionshift2J = 0
		pieceProtectTheKing = false
		get_node("SoundMovePiece").play()
		resetLastMovePlay()
		lastMovePlay()
	elif global_position.x >= get_parent().texture.get_width() + positionChessBoard.x\
		 or global_position.y >= get_parent().texture.get_height() + positionChessBoard.y :
		self.position = Vector2(Position.x, Position.y)

func moveFinal(checkColor):
	if VariableGlobal.startWhite == true:
		if checkColor == false:
			if white == true:
				moveWithPinWhite(1,-1,5) #Le premier paramètre restera toujours 1, le 2nd doit varier entre 1 et -1 (bas/haut).
			elif white == false:
				moveWithPinBlack(1,1,6) #Le premier paramètre restera toujours 1, le 2nd doit varier entre 1 et -1 (bas/haut).
		elif checkColor == true and pieceProtectTheKing == true:
			if pieceProtectsAgainstAnAttack == false:
				defenceMove(attackerPositionshiftI,attackerPositionshiftJ)
				defenceMove(attackerPositionshift2I,attackerPositionshift2J)
	if VariableGlobal.startWhite == false:
		if checkColor == false:
			if white == true:
				moveWithPinWhite(1,1,6)
			elif white == false:
				moveWithPinBlack(1,-1,5)
		elif checkColor == true and pieceProtectTheKing == true:
			if pieceProtectsAgainstAnAttack == false:
				defenceMove(attackerPositionshiftI,attackerPositionshiftJ)
				defenceMove(attackerPositionshift2I,attackerPositionshift2J)

func _on_area_2d_area_entered(area):
		var pieceName = area.get_parent().get_name()
		if promoteInProgress == false:
			if white == true and VariableGlobal.turnWhite == false:
				if "Black" in pieceName and dragging == false :
					VariableGlobalOption.pieceTaken = true
					get_node("/root/gameScreen/ChessBoard/" + pieceName).queue_free()
			elif white == false and VariableGlobal.turnWhite == true:
				if "White" in pieceName and dragging == false :
					VariableGlobalOption.pieceTaken = true
					get_node("/root/gameScreen/ChessBoard/" + pieceName).queue_free()
		elif promoteInProgress == true:
			if white == true and VariableGlobal.turnWhite == true:
				if "Black" in pieceName and dragging == false :
					VariableGlobalOption.pieceTaken = true
					get_node("/root/gameScreen/ChessBoard/" + pieceName).queue_free()
			elif white == false and VariableGlobal.turnWhite == false:
				if "White" in pieceName and dragging == false :
					VariableGlobalOption.pieceTaken = true
					get_node("/root/gameScreen/ChessBoard/" + pieceName).queue_free()

func findDirectionAttackRow(dx, dy, rookColor, queenColor):
	for f in range(1,9):
		if chessBoard[i+(dy*f)][j+(dx*f)] == "x":
			break
		elif chessBoard[i+(dy*f)][j+(dx*f)] != "0":
			if chessBoard[i+(dy*f)][j+(dx*f)].begins_with(rookColor)\
			or chessBoard[i+(dy*f)][j+(dx*f)].begins_with(queenColor):
				if dx == 0 and dy == -1:
					directionAttackProtectKing = "Haut"
				elif dx == 0 and dy == 1:
					directionAttackProtectKing = "Bas"
				elif dx == 1 and dy == 0:
					directionAttackProtectKing = "Droite"
				elif dx == -1 and dy == 0:
					directionAttackProtectKing = "Gauche"
				break
			else:
				break

func findDirectionAttackDiagonal(dx, dy, bishopColor, queenColor):
	for f in range(1,9):
		if chessBoard[i+(dy*f)][j+(dx*f)] == "x":
			break
		elif chessBoard[i+(dy*f)][j+(dx*f)] != "0":
			if chessBoard[i+(dy*f)][j+(dx*f)].begins_with(bishopColor)\
			or chessBoard[i+(dy*f)][j+(dx*f)].begins_with(queenColor):
				if dx == 1 and dy == -1:
					directionAttackProtectKing = "Haut/Droite"
				elif dx == -1 and dy == -1:
					directionAttackProtectKing = "Haut/Gauche"
				elif dx == 1 and dy == 1:
					directionAttackProtectKing = "Bas/Droite"
				elif dx == -1 and dy == 1:
					directionAttackProtectKing = "Bas/Gauche"
				break
			else:
				break

func directionOfAttack(bishopColor, rookColor, queenColor):
	#On regarde d'où vient l'attaque
	directionAttackProtectKing = ""
	#Lignes
	findDirectionAttackRow(0, -1, rookColor, queenColor)
	findDirectionAttackRow(0, 1, rookColor, queenColor)
	findDirectionAttackRow(1, 0, rookColor, queenColor)
	findDirectionAttackRow(1, 0, rookColor, queenColor)
	
	#Diagonales
	findDirectionAttackDiagonal(1, -1, bishopColor, queenColor)
	findDirectionAttackDiagonal(-1, -1, bishopColor, queenColor)
	findDirectionAttackDiagonal(1, 1, bishopColor, queenColor)
	findDirectionAttackDiagonal(-1, 1, bishopColor, queenColor)
	
func findtheKingIsBehind(dx, dy, kingColor):
	for f in range(1,9):
		if chessBoard[i+(dy*f)][j+(dx*f)] == "x":
			break
		elif chessBoard[i+(dy*f)][j+(dx*f)] != "0":
			if chessBoard[i+(dy*f)][j+(dx*f)].begins_with(kingColor):
				pieceProtectsAgainstAnAttack = true
				break
			else:
				break

func theKingIsBehind():
	#Ensuite, on regarde si le roi est derrière la pièce
	#qui le protège de l'attaque qui vient dans cette direction
	var kingColor = ""
	if VariableGlobal.turnWhite == true :
		directionOfAttack("BishopBlack", "RookBlack", "QueenBlack")
		kingColor = "KingWhite"
	elif VariableGlobal.turnWhite == false :
		directionOfAttack("BishopWhite", "RookWhite", "QueenWhite")
		kingColor = "KingBlack"
		
	pieceProtectsAgainstAnAttack = false
	if directionAttackProtectKing == "Haut":
		#On cherche vers le bas
		findtheKingIsBehind(0, 1, kingColor)
	elif directionAttackProtectKing == "Bas":
		#On cherche vers le haut
		findtheKingIsBehind(0, -1, kingColor)
	elif directionAttackProtectKing == "Droite":
		#On cherche vers la gauche
		findtheKingIsBehind(-1, 0, kingColor)
	elif directionAttackProtectKing == "Gauche":
		#On cherche vers la droite
		findtheKingIsBehind(1, 0, kingColor)
	elif directionAttackProtectKing == "Haut/Droite":
		#On cherche vers le Bas/Gauche
		findtheKingIsBehind(-1, 1, kingColor)
	elif directionAttackProtectKing == "Haut/Gauche":
		#On cherche vers le Bas/Droite
		findtheKingIsBehind(1, 1, kingColor)
	elif directionAttackProtectKing == "Bas/Droite":
		#On cherche vers le Haut/Gauche
		findtheKingIsBehind(-1, -1, kingColor)
	elif directionAttackProtectKing == "Bas/Gauche":
		#On cherche vers le Haut/Droite
		findtheKingIsBehind(1, -1, kingColor)

func promotion(color,knightColor,bishopColor,rookColor,queenColor):
	print("Enter in promotion")
	# Les noms des pièces de promotion et leurs positions x correspondantes
	var promotionPieces = [knightColor,bishopColor,rookColor,queenColor]
	var xPositions = [0, 200, 400, 600]
	
	for i in range(len(promotionPieces)):
		var promotion_sprite = Sprite2D.new()
		promotion_sprite.texture = load("res://Sprite/Piece/"+ color + "/" + promotionPieces[i] + ".png")
		promotion_sprite.centered = false
		promotion_sprite.position.x = xPositions[i]
		promotion_sprite.position.y = 300
		promotion_sprite.scale.x = 2
		promotion_sprite.scale.y = 2
		get_parent().add_child(promotion_sprite)
		
	promoteInProgress = true
	emit_signal("promotionTurn", promoteInProgress)
		
func namingPromotion(piece):
	var numberMax = 0
	var pieceFind = false
	for f in range(2,10): 
		for ff in range(2,10):
			if chessBoard[f][ff].begins_with(piece):
				pieceFind = true
				for fff in range(2,11):
					if chessBoard[f][ff] == piece + str(fff):
						if fff > numberMax:
							numberMax = fff
	if piece + str(numberMax) == piece + "0" and pieceFind == false:
		chessBoard[i][j] = piece
		set_name(piece)
	elif piece + str(numberMax) == piece + "0" and pieceFind == true:
		chessBoard[i][j] = piece + "2"
		set_name(piece)
	elif numberMax != 0:
		chessBoard[i][j] = piece + str(numberMax+1)
		set_name(piece + str(numberMax+1))

func deletePiecesSelectionPromotion():
	var numberOfChildren = get_parent().get_child_count()
	for f in range(numberOfChildren - 4, numberOfChildren):
		var child = get_parent().get_child(f)
		child.queue_free()

func promotionSelectionWhite():
	print("Enter in promotionSelection: ", self.nameOfPiece)
	var mousePos = get_local_mouse_position()
	var promotionOptions = [
	[0, 200, "KnightWhite", "Knight.gd", "res://Sprite/Piece/White/knight_white.png"],
	[200, 400, "BishopWhite", "Bishop.gd", "res://Sprite/Piece/White/bishop_white.png"],
	[400, 600, "RookWhite", "Rook.gd", "res://Sprite/Piece/White/rook_white.png"],
	[600, 800, "QueenWhite", "Queen.gd", "res://Sprite/Piece/White/queen_white.png"]
	]
	
	for f in range(4):
		print("Enter in promotionSelection boucle for")
		var minX = promotionOptions[f][0]
		var maxX = promotionOptions[f][1]
		var promotionName = promotionOptions[f][2]
		var scriptPath = promotionOptions[f][3]
		var texturePath = promotionOptions[f][4]
		
		if VariableGlobal.startWhite == true:
			if mousePos.x >= minX - position.x and mousePos.x <= maxX - position.x \
			and mousePos.y >= 250 and mousePos.y <= 450:
				print("Enter in promotionSelection selection piece")
				texture = load(texturePath)
				namingPromotion(promotionName)
				deletePiecesSelectionPromotion()
				promoteInProgress = false
				emit_signal("promotionTurn", promoteInProgress)
				VariableGlobal.turnWhite = !VariableGlobal.turnWhite
				get_parent().promotionID = get_instance_id()
				set_script(load("res://Script/" + scriptPath))
				break  # Sortir de la boucle après avoir trouvé une correspondance
		elif VariableGlobal.startWhite == false:
			if mousePos.x >= minX - position.x and mousePos.x <= maxX - position.x \
			and mousePos.y >= -450 and mousePos.y <= -250:
				print("Enter in promotionSelection selection piece")
				texture = load(texturePath)
				namingPromotion(promotionName)
				deletePiecesSelectionPromotion()
				promoteInProgress = false
				emit_signal("promotionTurn", promoteInProgress)
				VariableGlobal.turnWhite = !VariableGlobal.turnWhite
				get_parent().promotionID = get_instance_id()
				set_script(load("res://Script/" + scriptPath))
				break  # Sortir de la boucle après avoir trouvé une correspondance

func promotionSelectionBlack():
	print("Enter in promotionSelection: ", self.nameOfPiece)
	var mousePos = get_local_mouse_position()
	var promotionOptions = [
	[0, 200, "KnightBlack", "Knight.gd", "res://Sprite/Piece/Black/knight_black.png"],
	[200, 400, "BishopBlack", "Bishop.gd", "res://Sprite/Piece/Black/bishop_black.png"],
	[400, 600, "RookBlack", "Rook.gd", "res://Sprite/Piece/Black/rook_black.png"],
	[600, 800, "QueenBlack", "Queen.gd", "res://Sprite/Piece/Black/queen_black.png"]]

	for f in range(4):
		print("Enter in promotionSelection boucle for")
		var minX = promotionOptions[f][0]
		var maxX = promotionOptions[f][1]
		var promotionName = promotionOptions[f][2]
		var scriptPath = promotionOptions[f][3]
		var texturePath = promotionOptions[f][4]
		
		if VariableGlobal.startWhite == true:
			if mousePos.x >= minX - position.x and mousePos.x <= maxX - position.x \
			and mousePos.y >= -450 and mousePos.y <= -250:
				print("Enter in promotionSelection selection piece")
				texture = load(texturePath)
				namingPromotion(promotionName)
				deletePiecesSelectionPromotion()
				promoteInProgress = false
				emit_signal("promotionTurn", promoteInProgress)
				VariableGlobal.turnWhite = !VariableGlobal.turnWhite
				get_parent().promotionID = get_instance_id()
				set_script(load("res://Script/" + scriptPath))
				break  # Sortir de la boucle après avoir trouvé une correspondance
		elif VariableGlobal.startWhite == false:
			if mousePos.x >= minX - position.x and mousePos.x <= maxX - position.x \
			and mousePos.y >= 250 and mousePos.y <= 450:
				print("Enter in promotionSelection selection piece")
				texture = load(texturePath)
				namingPromotion(promotionName)
				deletePiecesSelectionPromotion()
				promoteInProgress = false
				emit_signal("promotionTurn", promoteInProgress)
				VariableGlobal.turnWhite = !VariableGlobal.turnWhite
				get_parent().promotionID = get_instance_id()
				set_script(load("res://Script/" + scriptPath))
				break  # Sortir de la boucle après avoir trouvé une correspondance

func get_promoteInProgress():
	return promoteInProgress
	

func createNewPieceMovePreview(dx,dy,f,color):
	var previewSprite = Sprite2D.new()
	previewSprite.texture = load("res://Sprite/Piece/"+ color + "/pawn_" + color.to_lower() +  ".png")
	previewSprite.centered = true
	previewSprite.position.x = Position.x + positionChessBoard.x + (100 * f*dx)
	previewSprite.position.y = Position.y + positionChessBoard.y + (100 * f*dy)
	previewSprite.z_index = 9
	previewSprite.modulate.a = 0.5
	get_node("/root/gameScreen/MovePreview").add_child(previewSprite)

func createNewPieceDefenceMovePreview(attackI, attackJ, color):
	var previewSprite = Sprite2D.new()
	previewSprite.texture = load("res://Sprite/Piece/"+ color + "/pawn_" + color.to_lower() +  ".png")
	previewSprite.centered = true
	previewSprite.position.x = Position.x + positionChessBoard.x + (100 * (attackJ - j))
	previewSprite.position.y = Position.y + positionChessBoard.y + (100 * (attackI - i))
	previewSprite.z_index = 9
	previewSprite.modulate.a = 0.1
	get_node("/root/gameScreen/MovePreview").add_child(previewSprite)

func previewMove(dx, dy, color, color2, attackI, attackJ, attack2I, attack2J):
	if (VariableGlobal.checkWhite == false and white == true)\
	or (VariableGlobal.checkBlack == false and white == false):
		for f in range (1,2):
			if chessBoard[i+(f*dy)][j+(f*dx)] == "x":
				break
			if chessBoard[i+(f*dy)][j+(f*dx)] == "0" and dx == 0 :
				createNewPieceMovePreview(dx,dy,f,color)
			elif chessBoard[i+(f*dy)][j+(f*dx)] != "0" and color2 in chessBoard[i+(f*dy)][j+(f*dx)]:
				createNewPieceMovePreview(dx,dy,f,color)
			elif chessBoard[i+(f*dy)][j+(f*dx)] != "0" and color in chessBoard[i+(f*dy)][j+(f*dx)]:
				break
	elif (VariableGlobal.checkWhite == true and white == true)\
	or (VariableGlobal.checkBlack == true and white == false):
		if chessBoard[attackI][attackJ] == "0"\
		or chessBoard[attackI][attackJ] != "0":
			createNewPieceDefenceMovePreview(attackI, attackJ, color)
		if chessBoard[attack2I][attack2J] == "0"\
		or chessBoard[attack2I][attack2J] != "0":
			createNewPieceDefenceMovePreview(attack2I, attack2J, color)

func previewMovePattern(dy,color, color2):
	if initialPosition == true :
		previewMove(0, 1*dy, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(0, 2*dy, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(-1, 1*dy, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(1, 1*dy, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
	elif initialPosition == false :
		previewMove(0, 1*dy, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(-1, 1*dy, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(1, 1*dy, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)

func previewAllMove():
	if VariableGlobal.startWhite == true:
		if white == true:
			previewMovePattern(-1,"White", "Black")
		elif white == false:
			previewMovePattern(1,"Black", "White")
	elif VariableGlobal.startWhite == false:
		if white == true:
			previewMovePattern(1,"White", "Black")
		elif white == false:
			previewMovePattern(-1,"Black", "White")

func deleteAllChildMovePreview():
	var numberOfChildren = get_node("/root/gameScreen/MovePreview").get_child_count()
	for f in range(numberOfChildren):
		get_node("/root/gameScreen/MovePreview").get_child(f).queue_free()

func lastMovePlay():
	modulate.r = 0
	modulate.g = 0

func resetLastMovePlay():
	var numberOfChildren = get_parent().get_child_count()
	
	for f in range(numberOfChildren):
		if get_parent().get_child(f).modulate.r == 0\
		and get_parent().get_child(f).modulate.g == 0:
			get_parent().get_child(f).modulate = Color(1, 1, 1, 1)
			break

func playWhite():
	if self.position.y == 650 :
		white = true
	elif self.position.y == 150:
		white = false
		
	if white == true:
		set_name("PawnWhite")
		nameOfPiece = get_name()
		if nameOfPiece == "PawnWhite":
			i = 8
			j = 2
			Position = Vector2(50, 650)
		for f in range(2, 9):
			if nameOfPiece == "PawnWhite" + str(f) :
				j = f + 1
				Position.x = ((50 + f * 100) - 100)
				Position.y = 650
	else:
		i = 3
		j = 2
		Position = Vector2(50, 150)
		texture = textureBlack
		set_name("PawnBlack")
		nameOfPiece = get_name()
		for f in range(2, 9):
			if nameOfPiece == "PawnBlack" + str(f) :
				j = f + 1
				Position.x = (50 + f * 100) - 100
				Position.y = 150
		
	print(nameOfPiece, " i: ", i, " j: ", j, " new position: ", Position )

func playBlack():
	if self.position.y == 650 :
		white = false
	elif self.position.y == 150:
		white = true
		
	if white == true:
		set_name("PawnWhite")
		nameOfPiece = get_name()
		if nameOfPiece == "PawnWhite":
			i = 3
			j = 2
			Position = Vector2(50, 150)
		for f in range(2, 9):
			if nameOfPiece == "PawnWhite" + str(f) :
				i = 3
				j = f + 1
				Position.x = ((50 + f * 100) - 100)
				Position.y = 150
	else:
		i = 8
		j = 2
		Position = Vector2(50, 650)
		texture = textureBlack
		set_name("PawnBlack")
		nameOfPiece = get_name()
		for f in range(2, 9):
			if nameOfPiece == "PawnBlack" + str(f) :
				j = f + 1
				Position.x = (50 + f * 100) - 100
				Position.y = 650
		
	print(nameOfPiece, " i: ", i, " j: ", j, " new position: ", Position )

func playModeEditor(color):
	print("Enter in playWhiteModeEditor")
	set_name("Pawn"+color)
	nameOfPiece = get_name()
	for f in range(10): 
		for ff in range(10):
			if global_position.x >= 100 + f * 100 and global_position.x <= 200 + f * 100\
			and global_position.y >= 100 + ff * 100 and global_position.y <= 200 + ff * 100:
				i = ff + 2
				j = f + 2
				Position.x = position.x
				Position.y = position.y
				chessBoard[i][j] = nameOfPiece.replace("@", "")
				if VariableGlobal.startWhite == true:
					if i != 8 and color == "White":
						initialPosition = false
					if i != 3 and color == "Black":
						initialPosition = false
				elif VariableGlobal.startWhite == false:
					if i != 3 and color == "White":
						initialPosition = false
					if i != 8 and color == "Black":
						initialPosition = false

func _on_area_2d_mouse_entered():
	if VariableGlobalOption.modeEditor == true and VariableGlobalOption.modeDelete == true:
		chessBoard[i][j] = "0"
		for f in range(0,12):
			print(chessBoard[f])
		queue_free()
