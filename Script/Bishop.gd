extends Sprite2D

var dragging = false
var clickRadius = 50
var dragOffset = Vector2()
var moveCase = VariableGlobal.one_move_case
var chessBoard = VariableGlobal.chessBoard
var i = 9
var j = 4
var Position = Vector2(250, 750)
@onready var nameOfPiece = get_name()
var white = true
var textureBlack = preload("res://Sprite/Piece/Black/bishop_black.png")

func _ready():
	await get_tree().process_frame
	if self.position.y == 50 :
		white = false
		
	if white == true:
		set_name("BishopWhite")
		nameOfPiece = get_name()
		if nameOfPiece == "BishopWhite2":
			i = 9
			j = 7
			Position = Vector2(550,750)
	else:
		i = 2
		j = 4
		Position = Vector2(250, 50)
		texture = textureBlack
		set_name("BishopBlack")
		nameOfPiece = get_name()
		if nameOfPiece == "BishopBlack2":
			i = 2
			j = 7
			Position = Vector2(550,50)
			
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
			if white == true and VariableGlobal.turnWhite == true:
				move(1,1)
				move(1,-1)
				move(-1,1)
				move(-1,-1)
			elif white == false and VariableGlobal.turnWhite == false:
				move(1,1)
				move(1,-1)
				move(-1,1)
				move(-1,-1)
			self.position = Vector2(Position.x, Position.y)
			dragging = false
			for f in range(0,12):
				print(chessBoard[f])
				
	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position
		
		
func move(dx, dy) :
#	En bas à droite(1,1), En haut à droite(1,-1), En bas à gauche (-1,1), en haut à gauche(-1,-1)
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

