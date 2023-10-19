extends Sprite2D

var dragging = false
var clickRadius = 50
var dragOffset = Vector2()
var moveCase = VariableGlobal.one_move_case
var chessBoard = VariableGlobal.chessBoard
var i = 9
var j = 2
var Position = Vector2(50, 750)
@onready var nameOfPiece = get_name()
var initialPosition = true
var white = true
var textureBlack = preload("res://Sprite/Piece/Black/rook_black.png")

func _ready():
	await get_tree().process_frame
	if self.position.y == 50 :
		white = false
		
	if white == true:
		set_name("RookWhite")
		nameOfPiece = get_name()
		if nameOfPiece == "RookWhite2":
			i = 9
			j = 9
			Position = Vector2(750,750)
	else:
		i = 2
		j = 2
		Position = Vector2(50, 50)
		texture = textureBlack
		set_name("RookBlack")
		nameOfPiece = get_name()
		if nameOfPiece == "RookBlack2":
			i = 2
			j = 9
			Position = Vector2(750,50)
		
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
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			for f in range (0,8):
				if white == true and VariableGlobal.turnWhite == true:
					move(1,0)
					move(0,1)
					move(-1,0)
					move(0,-1)
				elif white == false and VariableGlobal.turnWhite == false:
					move(1,0)
					move(0,1)
					move(-1,0)
					move(0,-1)
				initialPosition = false
			self.position = Vector2(Position.x, Position.y)
			dragging = false
			for f in range(0,12):
				print(chessBoard[f])
				
	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position
		
func move(dx, dy) :
#	A droite(1,0), En haut(0,1), A gauche(-1,0), En bas(0,-1)
	for f in range (1,8):
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
