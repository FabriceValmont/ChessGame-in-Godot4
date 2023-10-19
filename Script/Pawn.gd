extends Sprite2D

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
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.position).length() < clickRadius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
				dragOffset = event.position - self.position
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			if white == true and VariableGlobal.turnWhite == true:
				if initialPosition == true:
					if chessBoard[i-1][j] == "0":
						move(0,-1)
					if chessBoard[i-2][j] == "0":
						move(0,-2)
					if chessBoard[i-1][j-1] != "0":
						move(-1,-1)
					if chessBoard[i-1][j+1] != "0":
						move(1,-1)
					initialPosition = false
				else :
					if chessBoard[i-1][j] == "0":
						move(0,-1)
					if chessBoard[i-1][j-1] != "0":
						move(-1,-1)
					if chessBoard[i-1][j+1] != "0":
						move(1,-1)
			elif white == false and VariableGlobal.turnWhite == false:
				if initialPosition == true:
					if chessBoard[i+1][j] == "0":
						move(0,1)
					if chessBoard[i+2][j] == "0":
						move(0,2)
					if chessBoard[i+1][j-1] != "0":
						move(-1,1)
					if chessBoard[i+1][j+1] != "0":
						move(1,1)
					initialPosition = false
				else :
					if chessBoard[i+1][j] == "0":
						move(0,1)
					if chessBoard[i+1][j-1] != "0":
						move(-1,1)
					if chessBoard[i+1][j+1] != "0":
						move(1,1)
			self.position = Vector2(Position.x, Position.y)
			dragging = false
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
		and global_position.y >= (Position.y - 50) + targetCaseY and global_position.y <= (Position.y + 50) + targetCaseY:
			self.position = Vector2((Position.x + targetCaseX), (Position.y + targetCaseY))
			Position = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i+(dy*f)
			j=j+(dx*f)
			chessBoard[i][j] = nameOfPiece.replace("@", "")
			VariableGlobal.turnWhite = !VariableGlobal.turnWhite
			break
		elif global_position.x >= get_parent().texture.get_width() or global_position.y >= get_parent().texture.get_height() :
			self.position = Vector2(Position.x, Position.y)
			
func _on_area_2d_area_entered(area):
	var piece_name = area.get_parent().get_name()
	if white == true and VariableGlobal.turnWhite == false:
		if dragging == false and get_node("/root/ChessBoard/" + piece_name).white == false:
			get_node("/root/ChessBoard/" + piece_name).queue_free()
			print(piece_name)
		else:
			print(piece_name)
	else:
		pass
