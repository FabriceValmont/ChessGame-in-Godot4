extends Sprite2D

signal promotionTurn

var dragging = false
var clickRadius = 50
var dragOffset = Vector2()
var moveCase = VariableGlobal.one_move_case
var chessBoard = VariableGlobal.chessBoard
var i = 8
var j = 2
var Position = Vector2(50, 650)
@onready var nameOfPiece = get_name()
var initialPosition = true
var white = true
var textureBlack = preload("res://Sprite/Piece/Black/pawn_black.png")
var piece_protects_against_an_attack = false
var direction_attack_protect_king = ""
var promoteInProgress = false
var enPassant = false
var pieceProtectTheKing = false
var attacker_position_shift_i = 0
var attacker_position_shift_j = 0
var attacker_position_shift2_i = 0
var attacker_position_shift2_j = 0

func _ready():  
	await get_tree().process_frame
	if self.position.y == 150 :
		white = false
		
	if white == true:
		set_name("PawnWhite")
		nameOfPiece = get_name()
		for f in range(2, 9):
			if nameOfPiece == "PawnWhite" + str(f) :
				j = f + 1
				Position.x = (50 + f * 100) - 100  
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
	print(nameOfPiece, " i: ", i, " j: ", j, " new position: ", Position)

func _process(delta):
	pass

func _input(event):
	var mouse_pos = get_local_mouse_position()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if promoteInProgress == true and VariableGlobal.turnWhite == true and i == 2:
			promotionSelectionWhite()
		elif promoteInProgress == true and VariableGlobal.turnWhite == false and i == 9:
			promotionSelectionBlack()
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT\
	and promoteInProgress == false and VariableGlobal.checkmate == false:
		if (event.position - self.position).length() < clickRadius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
				dragOffset = event.position - self.position
				z_index = 10
				theKingIsBehind()
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			get_node("Area2D/CollisionShape2D").disabled = false
			if white == true and VariableGlobal.turnWhite == true:
				if VariableGlobal.checkWhite == false:
					moveWithPinWhite()
				elif VariableGlobal.checkWhite == true and pieceProtectTheKing == true:
					if piece_protects_against_an_attack == false:
						defenceMove(attacker_position_shift_i,attacker_position_shift_j)
						defenceMove(attacker_position_shift2_i,attacker_position_shift2_j)
			elif white == false and VariableGlobal.turnWhite == false:
				if VariableGlobal.checkBlack == false:
					moveWithPinBlack()
				elif VariableGlobal.checkBlack == true and pieceProtectTheKing == true:
					if piece_protects_against_an_attack == false:
						defenceMove(attacker_position_shift_i,attacker_position_shift_j)
						defenceMove(attacker_position_shift2_i,attacker_position_shift2_j)
			self.position = Vector2(Position.x, Position.y)
			dragging = false
			z_index = 0
			for f in range(0,12):
				print(chessBoard[f])
				
	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position
		get_node("Area2D/CollisionShape2D").disabled = true
		
func move(dx, dy) :
	for f in range (1,2):
		var targetCaseX = dx*(f*moveCase)
		var targetCaseY = dy*(f*moveCase)
		if global_position.x >= (Position.x - 50) + targetCaseX  and global_position.x <= (Position.x + 50) + targetCaseX \
		and global_position.y >= (Position.y - 50) + targetCaseY and global_position.y <= (Position.y + 50) + targetCaseY \
		and ((chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "Black" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == true and chessBoard[i+(dy*f)][j] == "0"\
		or (chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "White" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == false and chessBoard[i+(dy*f)][j] == "0"):
			self.position = Vector2((Position.x + targetCaseX), (Position.y + targetCaseY))
			Position = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i+(dy*f)
			j=j+(dx*f)
			chessBoard[i][j] = nameOfPiece.replace("@", "")
			if chessBoard[i][j].begins_with("PawnWhite") and i == 2:
				promotion("White","knight_white", "bishop_white", "rook_white", "queen_white")
			elif chessBoard[i][j].begins_with("PawnBlack") and i == 9:
				promotion("Black","knight_black", "bishop_black", "rook_black", "queen_black")
			if promoteInProgress == false:
				VariableGlobal.turnWhite = !VariableGlobal.turnWhite
			initialPosition = false
			break
		elif global_position.x >= get_parent().texture.get_width() or global_position.y >= get_parent().texture.get_height() :
			self.position = Vector2(Position.x, Position.y)
			
func moveWithPinWhite():
	if piece_protects_against_an_attack == false:
		if initialPosition == true:
			if chessBoard[i-1][j] == "0":
				move(0,-1)
			if chessBoard[i-2][j] == "0":
				move(0,-2)
			if chessBoard[i-1][j-1] != "0":
				move(-1,-1)
			if chessBoard[i-1][j+1] != "0":
				move(1,-1)
			enPassant = true
		else :
			if chessBoard[i-1][j] == "0":
				move(0,-1)
			if chessBoard[i-1][j-1] != "0":
				move(-1,-1)
			if chessBoard[i-1][j+1] != "0":
				move(1,-1)
			if i == 5 and chessBoard[i][j-1].begins_with("PawnBlack")\
			and get_node("/root/ChessBoard/" + chessBoard[i][j-1]).enPassant == true:
				get_node("/root/ChessBoard/" + chessBoard[i][j-1]).queue_free()
				chessBoard[i][j-1] = "0"
				move(-1,-1)
			if i == 5 and chessBoard[i][j+1].begins_with("PawnBlack")\
			and get_node("/root/ChessBoard/" + chessBoard[i][j+1]).enPassant == true:
				get_node("/root/ChessBoard/" + chessBoard[i][j+1]).queue_free()
				chessBoard[i][j+1] = "0"
				move(1,-1)
			enPassant = false
	elif piece_protects_against_an_attack == true:
		if initialPosition == true:
			if direction_attack_protect_king == "Haut":
				if chessBoard[i-1][j] == "0":
					move(0,-1)
				if chessBoard[i-2][j] == "0":
					move(0,-2)
			elif direction_attack_protect_king == "Haut/Gauche":
				if chessBoard[i-1][j-1] != "0":
					move(-1,-1)
			elif direction_attack_protect_king == "Haut/Droite":
				if chessBoard[i-1][j+1] != "0":
					move(1,-1)
			enPassant = true
		else :
			if direction_attack_protect_king == "Haut":
				if chessBoard[i-1][j] == "0":
					move(0,-1)
			elif direction_attack_protect_king == "Haut/Gauche":
				if chessBoard[i-1][j-1] != "0":
					move(-1,-1)
			elif direction_attack_protect_king == "Haut/Droite":
				if chessBoard[i-1][j+1] != "0":
					move(1,-1)
			enPassant = false

func moveWithPinBlack():
	if piece_protects_against_an_attack == false:
		if initialPosition == true:
			if chessBoard[i+1][j] == "0":
				move(0,1)
			if chessBoard[i+2][j] == "0":
				move(0,2)
			if chessBoard[i+1][j-1] != "0":
				move(-1,1)
			if chessBoard[i+1][j+1] != "0":
				move(1,1)
			enPassant = true
		else :
			if chessBoard[i+1][j] == "0":
				move(0,1)
			if chessBoard[i+1][j-1] != "0":
				move(-1,1)
			if chessBoard[i+1][j+1] != "0":
				move(1,1)
			if i == 6 and chessBoard[i][j-1].begins_with("PawnWhite")\
			and get_node("/root/ChessBoard/" + chessBoard[i][j-1]).enPassant == true:
				get_node("/root/ChessBoard/" + chessBoard[i][j-1]).queue_free()
				chessBoard[i][j-1] = "0"
				move(-1,1)
			if i == 6 and chessBoard[i][j+1].begins_with("PawnWhite")\
			and get_node("/root/ChessBoard/" + chessBoard[i][j+1]).enPassant == true:
				get_node("/root/ChessBoard/" + chessBoard[i][j+1]).queue_free()
				chessBoard[i][j+1] = "0"
				move(1,1)
			enPassant = false
	elif piece_protects_against_an_attack == true:
		if initialPosition == true:
			if direction_attack_protect_king == "Bas":
				if chessBoard[i+1][j] == "0":
					move(0,1)
				if chessBoard[i+2][j] == "0":
					move(0,2)
			elif direction_attack_protect_king == "Bas/Gauche":
				if chessBoard[i+1][j-1] != "0":
					move(-1,1)
			elif direction_attack_protect_king == "Bas/Droite":
				if chessBoard[i+1][j+1] != "0":
					move(1,1)
			enPassant = true
		else :
			if direction_attack_protect_king == "Bas":
				if chessBoard[i+1][j] == "0":
					move(0,1)
			elif direction_attack_protect_king == "Bas/Gauche":
				if chessBoard[i+1][j-1] != "0":
					move(-1,1)
			elif direction_attack_protect_king == "Bas/Droite":
				if chessBoard[i+1][j+1] != "0":
					move(1,1)
			enPassant = false

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
		if chessBoard[i][j].begins_with("PawnWhite") and i == 2:
			promotion("White","knight_white", "bishop_white", "rook_white", "queen_white")
		elif chessBoard[i][j].begins_with("PawnBlack") and i == 9:
			promotion("Black","knight_black", "bishop_black", "rook_black", "queen_black")
		if promoteInProgress == false:
			VariableGlobal.turnWhite = !VariableGlobal.turnWhite
		initialPosition = false
		attacker_position_shift_i = 0
		attacker_position_shift_j = 0
		attacker_position_shift2_i = 0
		attacker_position_shift2_j = 0
		pieceProtectTheKing = false
	elif global_position.x >= get_parent().texture.get_width() or global_position.y >= get_parent().texture.get_height() :
		self.position = Vector2(Position.x, Position.y)

func _on_area_2d_area_entered(area):
		var piece_name = area.get_parent().get_name()
		if white == true and VariableGlobal.turnWhite == false:
			if "Black" in piece_name and dragging == false :
				get_node("/root/ChessBoard/" + piece_name).queue_free()
		elif white == false and VariableGlobal.turnWhite == true:
			if "White" in piece_name and dragging == false :
				get_node("/root/ChessBoard/" + piece_name).queue_free()
				
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

func promotion(color,knightColor,bishopColor,rookColor,queenColor):
	print("Enter in promotion")
	# Les noms des pièces de promotion et leurs positions x correspondantes
	var promotion_pieces = [knightColor,bishopColor,rookColor,queenColor]
	var x_positions = [0, 200, 400, 600]
	
	for i in range(len(promotion_pieces)):
		var promotion_sprite = Sprite2D.new()
		promotion_sprite.texture = load("res://Sprite/Piece/"+ color + "/" + promotion_pieces[i] + ".png")
		promotion_sprite.centered = false
		promotion_sprite.position.x = x_positions[i]
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
						#print(piece + str(fff))
						#print("fff: ",fff)
						if fff > numberMax:
							numberMax = fff
							#print("numberMax: ",numberMax)
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
	var num_children = get_parent().get_child_count()
	for f in range(num_children - 4, num_children):
		var child = get_parent().get_child(f)
		child.queue_free()

func promotionSelectionWhite():
	print("Enter in promotionSelection: ", self.nameOfPiece)
	var mouse_pos = get_local_mouse_position()
	var promotionOptions = [
	[0, 200, "KnightWhite", "Knight.gd", "res://Sprite/Piece/White/knight_white.png"],
	[200, 400, "BishopWhite", "Bishop.gd", "res://Sprite/Piece/White/bishop_white.png"],
	[400, 600, "RookWhite", "Rook.gd", "res://Sprite/Piece/White/rook_white.png"],
	[600, 800, "QueenWhite", "Queen.gd", "res://Sprite/Piece/White/queen_white.png"]]

	for f in range(4):
		print("Enter in promotionSelection boucle for")
		var minX = promotionOptions[f][0]
		var maxX = promotionOptions[f][1]
		var promotionName = promotionOptions[f][2]
		var scriptPath = promotionOptions[f][3]
		var texturePath = promotionOptions[f][4]
		
		if mouse_pos.x >= minX - position.x and mouse_pos.x <= maxX - position.x \
		and mouse_pos.y >= 250 and mouse_pos.y <= 450:
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
	var mouse_pos = get_local_mouse_position()
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
		
		if mouse_pos.x >= minX - position.x and mouse_pos.x <= maxX - position.x \
		and mouse_pos.y >= -450 and mouse_pos.y <= -250:
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
