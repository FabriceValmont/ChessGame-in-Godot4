extends Sprite2D

var dragging = false
var clickRadius = 50
var dragOffset = Vector2()
var moveCase = VariableGlobal.one_move_case
var chessBoard = VariableGlobal.chessBoard
var i = 9
var j = 5
var Position = Vector2(350, 750)
@onready var nameOfPiece = get_name()
var initialPosition = true
var white = true
var textureBlack = preload("res://Sprite/Piece/Black/queen_black.png")
var maxMoveUp = 1
var maxMoveDown = 1
var maxMoveLeft = 1
var maxMoveRight = 1
var maxMoveDownRight = 1
var maxMoveDownLeft = 1
var maxMoveUpLeft = 1
var maxMoveUpRight = 1
var piece_protects_against_an_attack = false
var direction_attack_protect_king = ""
var promoteInProgress = false
var pieceProtectTheKing = false
var attacker_position_shift_i = 0
var attacker_position_shift_j = 0
var attacker_position_shift2_i = 0
var attacker_position_shift2_j = 0
var attacker_position_shift3_i = 0
var attacker_position_shift3_j = 0

func _ready():
	await get_tree().process_frame
	if self.position.y == 50 :
		white = false
		
	if white == true:
		set_name("QueenWhite")
		nameOfPiece = get_name()
	else:
		i = 2
		j = 5
		Position = Vector2(350, 50)
		texture = textureBlack
		set_name("QueenBlack")
		nameOfPiece = get_name()
			
	print(nameOfPiece, " i: ", i, " j: ", j, " new position: ", Position )

func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT\
	and promoteInProgress == false and VariableGlobal.checkmate == false:
		if (event.position - self.position).length() < clickRadius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
				dragOffset = event.position - self.position
				z_index = 10
				maxMoveRight = checkMaxMove(1,0)
				maxMoveLeft = checkMaxMove(-1,0)
				maxMoveDown = checkMaxMove(0,1)
				maxMoveUp = checkMaxMove(0,-1)
				maxMoveDownRight = checkMaxMove(1,1)
				maxMoveDownLeft = checkMaxMove(-1,1)
				maxMoveUpLeft = checkMaxMove(-1,-1)
				maxMoveUpRight = checkMaxMove(1,-1)
				theKingIsBehind()
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			get_node("Area2D/CollisionShape2D").disabled = false
			if white == true and VariableGlobal.turnWhite == true:
				if VariableGlobal.checkWhite == false:
					moveWithPin()
				elif VariableGlobal.checkWhite == true and pieceProtectTheKing == true:
					if piece_protects_against_an_attack == false:
						defenceMove(attacker_position_shift_i,attacker_position_shift_j)
						defenceMove(attacker_position_shift2_i,attacker_position_shift2_j)
						defenceMove(attacker_position_shift3_i,attacker_position_shift3_j)
			elif white == false and VariableGlobal.turnWhite == false:
				if VariableGlobal.checkBlack == false:
					moveWithPin()
				elif VariableGlobal.checkBlack == true and pieceProtectTheKing == true:
					if piece_protects_against_an_attack == false:
						defenceMove(attacker_position_shift_i,attacker_position_shift_j)
						defenceMove(attacker_position_shift2_i,attacker_position_shift2_j)
						defenceMove(attacker_position_shift3_i,attacker_position_shift3_j)
			self.position = Vector2(Position.x, Position.y)
			dragging = false
			z_index = 0
			for f in range(0,12):
				print(chessBoard[f])
				
	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position
		get_node("Area2D/CollisionShape2D").disabled = true
		
func move(dx, dy, maxMove) :
	for f in range (1,maxMove):
		var targetCaseX = dx*(f*moveCase)
		var targetCaseY = dy*(f*moveCase)
		if global_position.x >= (Position.x - 50) + targetCaseX  and global_position.x <= (Position.x + 50) + targetCaseX \
		and global_position.y >= (Position.y - 50) + targetCaseY and global_position.y <= (Position.y + 50) + targetCaseY \
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
			break
		elif global_position.x >= get_parent().texture.get_width() or global_position.y >= get_parent().texture.get_height() :
			self.position = Vector2(Position.x, Position.y)
			
func defenceMove(attacki,attackj):
	print("Enter in defenceMove")
	var targetCaseX = (attackj - j) * moveCase
	var targetCaseY = (attacki - i) * moveCase
	if global_position.x >= (Position.x - 50) + targetCaseX  and global_position.x <= (Position.x + 50) + targetCaseX \
	and global_position.y >= (Position.y - 50) + targetCaseY and global_position.y <= (Position.y + 50) + targetCaseY \
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
		attacker_position_shift_i = 0
		attacker_position_shift_j = 0
		attacker_position_shift2_i = 0
		attacker_position_shift2_j = 0
		attacker_position_shift3_i = 0
		attacker_position_shift3_j = 0
		pieceProtectTheKing = false
	elif global_position.x >= get_parent().texture.get_width() or global_position.y >= get_parent().texture.get_height() :
		self.position = Vector2(Position.x, Position.y)
		
func moveWithPin():
	if piece_protects_against_an_attack == false:
		move(1,0, maxMoveRight)
		move(0,1, maxMoveDown)
		move(-1,0, maxMoveLeft)
		move(0,-1, maxMoveUp)
		move(1,1, maxMoveDownRight)
		move(1,-1, maxMoveUpRight)
		move(-1,1, maxMoveDownLeft)
		move(-1,-1, maxMoveUpLeft)
	elif piece_protects_against_an_attack == true:
		if direction_attack_protect_king == "Haut" or direction_attack_protect_king == "Bas":
			move(0,-1, maxMoveUp)
			move(0,1, maxMoveDown)
		elif direction_attack_protect_king == "Droite" or direction_attack_protect_king == "Gauche":
			move(1,0, maxMoveRight)
			move(-1,0, maxMoveLeft)
		elif direction_attack_protect_king == "Haut/Droite" or direction_attack_protect_king == "Bas/Gauche":
			move(1,-1, maxMoveUpRight)
			move(-1,1, maxMoveDownLeft)
		elif direction_attack_protect_king == "Haut/Gauche" or direction_attack_protect_king == "Bas/Droite":
			move(-1,-1, maxMoveUpLeft)
			move(1,1, maxMoveDownRight)
			
func _on_area_2d_area_entered(area):
		var piece_name = area.get_parent().get_name()
		if white == true and VariableGlobal.turnWhite == false:
			if "Black" in piece_name and dragging == false :
				get_node("/root/ChessBoard/" + piece_name).queue_free()
		elif white == false and VariableGlobal.turnWhite == true:
			if "White" in piece_name and dragging == false :
				get_node("/root/ChessBoard/" + piece_name).queue_free()
				
func checkMaxMove(dx, dy):
	for f in range (1,9):
		if chessBoard[i+(f*dy)][j+(f*dx)] != "0":
			if chessBoard[i+(f*dy)][j+(f*dx)] == "x":
				return f
			else:
				return f + 1
				
func directionOfAttack(bishopColor, rookColor, queenColor):
	#On regarde d'où vient l'attaque
	#Lignes
	#Vers le haut
	direction_attack_protect_king = ""
	for f in range(1,9):
		if chessBoard[i-f][j] == "x":
			break
		elif chessBoard[i-f][j] != "0":
			
			if chessBoard[i-f][j].begins_with(rookColor)\
			or chessBoard[i-f][j].begins_with(queenColor):
				direction_attack_protect_king = "Haut"
				break
			else:
				break
	#Vers le bas
	for f in range(1,9):
		if chessBoard[i+f][j] == "x":
			break
		elif chessBoard[i+f][j] != "0":
			
			if chessBoard[i+f][j].begins_with(rookColor)\
			or chessBoard[i+f][j].begins_with(queenColor):
				direction_attack_protect_king = "Bas"
				break
			else:
				break
	#Vers la droite
	for f in range(1,9):
		if chessBoard[i][j+f] == "x":
			break
		elif chessBoard[i][j+f] != "0":
			
			if chessBoard[i][j+f].begins_with(rookColor)\
			or chessBoard[i][j+f].begins_with(queenColor):
				direction_attack_protect_king = "Droite"
				break
			else:
				break
	#Vers la gauche
	for f in range(1,9):
		if chessBoard[i][j-f] == "x":
			break
		elif chessBoard[i][j-f] != "0":
			
			if chessBoard[i][j-f].begins_with(rookColor)\
			or chessBoard[i][j-f].begins_with(queenColor):
				direction_attack_protect_king = "Gauche"
				break
			else:
				break
	#Diagonales
	#Vers le haut à droite
	for f in range(1,9):
		if chessBoard[i-f][j+f] == "x":
			break
		elif chessBoard[i-f][j+f] != "0":
			
			if chessBoard[i-f][j+f].begins_with(bishopColor)\
			or chessBoard[i-f][j+f].begins_with(queenColor):
				direction_attack_protect_king = "Haut/Droite"
				break
			else:
				break
	#Vers le haut à gauche
	for f in range(1,9):
		if chessBoard[i-f][j-f] == "x":
			break
		elif chessBoard[i-f][j-f] != "0":
			
			if chessBoard[i-f][j-f].begins_with(bishopColor)\
			or chessBoard[i-f][j-f].begins_with(queenColor):
				direction_attack_protect_king = "Haut/Gauche"
				break
			else:
				break
	#Vers le bas à droite
	for f in range(1,9):
		if chessBoard[i+f][j+f] == "x":
			break
		elif chessBoard[i+f][j+f] != "0":
			
			if chessBoard[i+f][j+f].begins_with(bishopColor)\
			or chessBoard[i+f][j+f].begins_with(queenColor):
				direction_attack_protect_king = "Bas/Droite"
				break
			else:
				break
	#Vers le bas à gauche
	for f in range(1,9):
		if chessBoard[i+f][j-f] == "x":
			break
		elif chessBoard[i+f][j-f] != "0":
			
			if chessBoard[i+f][j-f].begins_with(bishopColor)\
			or chessBoard[i+f][j-f].begins_with(queenColor):
				direction_attack_protect_king = "Bas/Gauche"
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
		
	piece_protects_against_an_attack = false
	if direction_attack_protect_king == "Haut":
		#On cherche vers le bas
		for f in range(1,9):
			if chessBoard[i+f][j] == "x":
				break
			elif chessBoard[i+f][j] != "0":
				
				if chessBoard[i+f][j].begins_with(kingColor):
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Bas":
		#On cherche vers le haut
		for f in range(1,9):
			if chessBoard[i-f][j] == "x":
				break
			elif chessBoard[i-f][j] != "0":
				
				if chessBoard[i-f][j].begins_with(kingColor):
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Droite":
		#On cherche vers la gauche
		for f in range(1,9):
			if chessBoard[i][j-f] == "x":
				break
			elif chessBoard[i][j-f] != "0":
				
				if chessBoard[i][j-f].begins_with(kingColor):
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Gauche":
		#On cherche vers la droite
		for f in range(1,9):
			if chessBoard[i][j+f] == "x":
				break
			elif chessBoard[i][j+f] != "0":
				
				if chessBoard[i][j+f].begins_with(kingColor):
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Haut/Droite":
		#On cherche vers le Bas/Gauche
		for f in range(1,9):
			if chessBoard[i+f][j-f] == "x":
				break
			elif chessBoard[i+f][j-f] != "0":
				
				if chessBoard[i+f][j-f].begins_with(kingColor):
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Haut/Gauche":
		#On cherche vers le Bas/Droite
		for f in range(1,9):
			if chessBoard[i+f][j+f] == "x":
				break
			elif chessBoard[i+f][j+f] != "0":
				
				if chessBoard[i+f][j+f].begins_with(kingColor):
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Bas/Droite":
		#On cherche vers le Haut/Gauche
		for f in range(1,9):
			if chessBoard[i-f][j-f] == "x":
				break
			elif chessBoard[i-f][j-f] != "0":
				
				if chessBoard[i-f][j-f].begins_with(kingColor):
					piece_protects_against_an_attack = true
					break
				else:
					break
	elif direction_attack_protect_king == "Bas/Gauche":
		#On cherche vers le Haut/Droite
		for f in range(1,9):
			if chessBoard[i-f][j+f] == "x":
				break
			elif chessBoard[i-f][j+f] != "0":
				
				if chessBoard[i-f][j+f].begins_with(kingColor):
					piece_protects_against_an_attack = true
					break
				else:
					break

func get_promoteInProgress():
	return promoteInProgress
