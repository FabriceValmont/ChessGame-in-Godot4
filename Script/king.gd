extends Sprite2D

signal kingSizeCastelingSignal
signal queenSizeCastelingSignal

var dragging = false
var clickRadius = 50
var dragOffset = Vector2()
var moveCase = VariableGlobal.one_move_case
var chessBoard = VariableGlobal.chessBoard
var attackWhite = VariableGlobal.attack_piece_white_on_the_chessboard
var attackBlack = VariableGlobal.attack_piece_black_on_the_chessboard
var i = 9
var j = 6
var Position = Vector2(450, 750)
@onready var nameOfPiece = get_name()
var initialPosition = true
var white = true
var textureBlack = preload("res://Sprite/Piece/Black/king_black.png")
var checkMate = false

func _ready():
	await get_tree().process_frame
	if self.position.y == 50 :
		white = false
		
	if white == true:
		set_name("KingWhite")
		nameOfPiece = get_name()
	else:
		i = 2
		j = 6
		Position = Vector2(450, 50)
		texture = textureBlack
		set_name("KingBlack")
		nameOfPiece = get_name()
			
	print(nameOfPiece, " i: ", i, " j: ", j, " new position: ", Position )

func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.position).length() < clickRadius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
				dragOffset = event.position - self.position
				z_index = 10
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			if white == true and VariableGlobal.turnWhite == true:
				move(1,0)
				move(0,1)
				move(-1,0)
				move(0,-1)
				move(1,1)
				move(1,-1)
				move(-1,1)
				move(-1,-1)
				kingSizeCasteling(1,1,"RookWhite2",attackBlack)
				queenSizeCasteling(-1,1,"RookWhite",attackBlack)
			elif white == false and VariableGlobal.turnWhite == false:
				move(1,0)
				move(0,1)
				move(-1,0)
				move(0,-1)
				move(1,1)
				move(1,-1)
				move(-1,1)
				move(-1,-1)
				kingSizeCasteling(1,1,"RookBlack2", attackWhite)
				queenSizeCasteling(-1,1,"RookBlack", attackWhite)
			self.position = Vector2(Position.x, Position.y)
			dragging = false
			z_index = 0
			for f in range(0,12):
				print(chessBoard[f])
			
	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position
		
		
func move(dx, dy) :
	for f in range (1,2):
		var targetCaseX = dx*(f*moveCase)
		var targetCaseY = dy*(f*moveCase)
		if global_position.x >= (Position.x - 50) + targetCaseX  and global_position.x <= (Position.x + 50) + targetCaseX \
		and global_position.y >= (Position.y - 50) + targetCaseY and global_position.y <= (Position.y + 50) + targetCaseY \
		and ((chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "Black" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == true\
		 and VariableGlobal.attack_piece_black_on_the_chessboard[i+(dy*f)][j+(dx*f)] == 0\
		or (chessBoard[i+(dy*f)][j+(dx*f)] == "0" or "White" in chessBoard[i+(dy*f)][j+(dx*f)]) and VariableGlobal.turnWhite == false\
		 and VariableGlobal.attack_piece_white_on_the_chessboard[i+(dy*f)][j+(dx*f)] == 0):
			self.position = Vector2((Position.x + targetCaseX), (Position.y + targetCaseY))
			Position = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i+(dy*f)
			j=j+(dx*f)
			chessBoard[i][j] = nameOfPiece.replace("@", "")
			initialPosition = false
			VariableGlobal.turnWhite = !VariableGlobal.turnWhite
			break
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
				
func kingSizeCasteling(dx, dy, rookColor, attackColor):
		var targetCaseX = dx*(2*moveCase)
		var targetCaseY = dy*(0*moveCase)
		if global_position.x >= (Position.x - 50) + targetCaseX  and global_position.x <= (Position.x + 50) + targetCaseX \
		and global_position.y >= (Position.y - 50) + targetCaseY and global_position.y <= (Position.y + 50) + targetCaseY \
		and chessBoard[i][j+1] == "0" and chessBoard[i][j+2] == "0" and chessBoard[i][j+3].begins_with("Rook") \
		and attackColor[i][j] == 0 and attackColor[i][j+1] == 0 and attackColor[i][j+2] == 0 and initialPosition == true \
		and get_node("/root/ChessBoard/" + rookColor).initialPosition == true:
			self.position = Vector2((Position.x + targetCaseX), (Position.y + targetCaseY))
			Position = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i
			j=j+(dx*2)
			chessBoard[i][j] = nameOfPiece.replace("@", "")
			initialPosition = false
			VariableGlobal.turnWhite = !VariableGlobal.turnWhite
			emit_signal("kingSizeCastelingSignal")
		elif global_position.x >= get_parent().texture.get_width() or global_position.y >= get_parent().texture.get_height() :
			self.position = Vector2(Position.x, Position.y)
			
func queenSizeCasteling(dx, dy, rookColor, attackColor):
		var targetCaseX = dx*(2*moveCase)
		var targetCaseY = dy*(0*moveCase)
		if global_position.x >= (Position.x - 50) + targetCaseX  and global_position.x <= (Position.x + 50) + targetCaseX \
		and global_position.y >= (Position.y - 50) + targetCaseY and global_position.y <= (Position.y + 50) + targetCaseY \
		and chessBoard[i][j-1] == "0" and chessBoard[i][j-2] == "0" and chessBoard[i][j-3] == "0" and chessBoard[i][j-4].begins_with("Rook") \
		and attackColor[i][j] == 0 and attackColor[i][j-1] == 0 and attackColor[i][j-2] == 0  and attackColor[i][j-3] == 0 and initialPosition == true \
		and get_node("/root/ChessBoard/" + rookColor).initialPosition == true:
			self.position = Vector2((Position.x + targetCaseX), (Position.y + targetCaseY))
			Position = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i
			j=j+(dx*2)
			chessBoard[i][j] = nameOfPiece.replace("@", "")
			initialPosition = false
			VariableGlobal.turnWhite = !VariableGlobal.turnWhite
			emit_signal("queenSizeCastelingSignal")
		elif global_position.x >= get_parent().texture.get_width() or global_position.y >= get_parent().texture.get_height() :
			self.position = Vector2(Position.x, Position.y)
