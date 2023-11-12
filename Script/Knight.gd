extends Sprite2D

var dragging = false
var clickRadius = 50
var dragOffset = Vector2()
var moveCase = VariableGlobal.oneMoveCase
var chessBoard = VariableGlobal.chessBoard
var i = 9
var j = 3
var positionChessBoard
var Position = Vector2(150, 750)
@onready var nameOfPiece = get_name()
var initialPosition = true
var white = true
var textureWhite = preload("res://Sprite/Piece/White/knight_white.png")
var textureBlack = preload("res://Sprite/Piece/Black/knight_black.png")
var pieceProtectsAgainstAnAttack = false
var directionAttackProtectKing = ""
var promoteInProgress = false
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
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT\
	and promoteInProgress == false and VariableGlobal.checkmate == false:
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
			for f in range (0,8):
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
	for f in range (1,8):
		var targetCaseX = dx*(f*moveCase)
		var targetCaseY = dy*(f*moveCase)
		var newTargetCaseX = targetCaseX + positionChessBoard.x
		var newTargetCaseY = targetCaseY + positionChessBoard.y
		if global_position.x >= (Position.x - 50) + newTargetCaseX and global_position.x <= (Position.x + 50) + newTargetCaseX \
		and global_position.y >= (Position.y - 50) + newTargetCaseY and global_position.y <= (Position.y + 50) + newTargetCaseY \
		and ((chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "Black" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == true\
		or (chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "White" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == false):
			self.position = Vector2((Position.x + targetCaseX), (Position.y + targetCaseY))
			Position = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i+(dy*f)
			j=j+(dx*f)
			chessBoard[i][j] = nameOfPiece.replace("@", "")
			VariableGlobal.turnWhite = !VariableGlobal.turnWhite
			initialPosition = false
			get_node("SoundMovePiece").play()
			resetLastMovePlay()
			lastMovePlay()
			break
		elif global_position.x >= get_parent().texture.get_width() + positionChessBoard.x\
		 or global_position.y >= get_parent().texture.get_height() + positionChessBoard.y :
			self.position = Vector2(Position.x, Position.y)
			
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
		
func moveWithPin():
	if pieceProtectsAgainstAnAttack == false:
		move(1,-2)
		move(-1,-2)
		move(1,2)
		move(-1,2)
		move(2,-1)
		move(-2,-1)
		move(2,1)
		move(-2,1)
			
func moveFinal(checkColor):
	if checkColor == false:
		moveWithPin()
	elif checkColor == true and pieceProtectTheKing == true:
		if pieceProtectsAgainstAnAttack == false:
			defenceMove(attackerPositionshiftI,attackerPositionshiftJ)
			defenceMove(attackerPositionshift2I,attackerPositionshift2J)
			
func _on_area_2d_area_entered(area):
		var pieceName = area.get_parent().get_name()
		if white == true and VariableGlobal.turnWhite == false:
			if "Black" in pieceName and dragging == false :
				VariableGlobalOption.pieceTaken = true
				get_node("/root/gameScreen/ChessBoard/" + pieceName).queue_free()
		elif white == false and VariableGlobal.turnWhite == true:
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

func get_promoteInProgress():
	return promoteInProgress
	
func createNewPieceMovePreview(dx,dy,f,color):
	var previewSprite = Sprite2D.new()
	previewSprite.texture = load("res://Sprite/Piece/"+ color + "/knight_" + color.to_lower() +  ".png")
	previewSprite.centered = true
	previewSprite.position.x = Position.x + positionChessBoard.x + (100 * f*dx)
	previewSprite.position.y = Position.y + positionChessBoard.y + (100 * f*dy)
	previewSprite.z_index = 9
	previewSprite.modulate.a = 0.5
	get_node("/root/gameScreen/MovePreview").add_child(previewSprite)

func createNewPieceDefenceMovePreview(attackI, attackJ, color):
	var previewSprite = Sprite2D.new()
	previewSprite.texture = load("res://Sprite/Piece/"+ color + "/knight_" + color.to_lower() +  ".png")
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
			if chessBoard[i+(f*dy)][j+(f*dx)] == "0":
				createNewPieceMovePreview(dx,dy,f,color)
			elif chessBoard[i+(f*dy)][j+(f*dx)] != "0" and color2 in chessBoard[i+(f*dy)][j+(f*dx)]:
				createNewPieceMovePreview(dx,dy,f,color)
				break
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
			
func previewMovePattern(color, color2):
	if pieceProtectsAgainstAnAttack == false:
		previewMove(1, -2, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(-1, -2, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(1, 2, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(-1, 2, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(2, -1, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(-2, -1, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(2, 1, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
		previewMove(-2, 1, color, color2,attackerPositionshiftI,attackerPositionshiftJ,attackerPositionshift2I,attackerPositionshift2J)
			
func previewAllMove():
	if white == true:
		previewMovePattern("White", "Black")
	elif white == false:
		previewMovePattern("Black", "White")

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
	if self.position.y == 750 :
		white = true
	elif self.position.y == 50:
		white = false
		
	if white == true:
		set_name("KnightWhite") #Si la pièce est déjà créer alors l'autre se nommera avec un chiffre à la fin
		nameOfPiece = get_name()
		if nameOfPiece == "KnightWhite":
			i = 9
			j = 3
			Position = Vector2(150,750)
		elif nameOfPiece == "KnightWhite2":
			i = 9
			j = 8
			Position = Vector2(650,750)
	else:
		i = 2
		j = 3
		Position = Vector2(150, 50)
		texture = textureBlack
		set_name("KnightBlack")
		nameOfPiece = get_name()
		if nameOfPiece == "KnightBlack2":
			i = 2
			j = 8
			Position = Vector2(650,50)
		
	print(nameOfPiece, " i: ", i, " j: ", j, " new position: ", Position )

func playBlack():
	if self.position.y == 750 :
		white = false
	elif self.position.y == 50:
		white = true
		
	if white == true:
		set_name("KnightWhite") #Si la pièce est déjà créer alors l'autre se nommera avec un chiffre à la fin
		nameOfPiece = get_name()
		if nameOfPiece == "KnightWhite":
			i = 2
			j = 3
			Position = Vector2(150,50)
		elif nameOfPiece == "KnightWhite2":
			i = 2
			j = 8
			Position = Vector2(650,50)
	else:
		i = 9
		j = 3
		Position = Vector2(150, 750)
		texture = textureBlack
		set_name("KnightBlack")
		nameOfPiece = get_name()
		if nameOfPiece == "KnightBlack2":
			i = 9
			j = 8
			Position = Vector2(650,750)
		
	print(nameOfPiece, " i: ", i, " j: ", j, " new position: ", Position )

func playModeEditor(color):
	print("Enter in playWhiteModeEditor")
	set_name("Knight"+color)
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

func _on_area_2d_mouse_entered():
	if VariableGlobalOption.modeEditor == true and VariableGlobalOption.modeDelete == true:
		chessBoard[i][j] = "0"
		for f in range(0,12):
			print(chessBoard[f])
		queue_free()
