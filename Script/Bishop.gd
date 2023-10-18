extends Sprite2D

var dragging = false
var click_radius = 100
var drag_offset = Vector2()
var new_position = Vector2(250, 750)
var move_case = VariableGlobal.one_move_case
var chessBoard = [["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
["x", "x", "rook_black", "knight_black", "bishop_black", "queen_black", "king_black", "bishop_black", "knight_black", "rook_black", "x", "x"],
["x", "x", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "pawn_black", "x", "x"],
["x", "x", "0", "0", "0", "0", "0", "0", "0", "0", "x", "x"],
["x", "x", "0", "0", "0", "0", "0", "0", "0", "0", "x", "x"],
["x", "x", "0", "0", "0", "0", "0", "0", "0", "0", "x", "x"],
["x", "x", "0", "0", "0", "0", "0", "0", "0", "0", "x", "x"],
["x", "x", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "pawn_white", "x", "x"],
["x", "x", "rook_white", "knight_white", "bishop_white", "queen_white", "king_white", "bishop_white", "knight_white", "rook_white", "x", "x"],
["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],]
var i = 9
var j = 4
@onready var name_of_piece = get_node(".").get_name()

func _ready():
	if name_of_piece == "Bishop2":
		i = 9
		j = 7
		new_position = Vector2(550,750)
	print(name_of_piece, " i: ", i, " j: ", j )

func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.position).length() < click_radius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
				drag_offset = event.position - self.position
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			move(1,1)
			move(1,-1)
			move(-1,1)
			move(-1,-1)
			self.position = Vector2(new_position.x, new_position.y)
			dragging = false
		
		for f in range(0,12):
			if name_of_piece == "Bishop":
				print(chessBoard[f])
		

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position
		
		
func move(dx, dy) :
#	En bas à droite(1,1), En haut à droite(1,-1), En bas à gauche (-1,1), en haut à gauche(-1,-1)
	for f in range (0,8):
		if global_position.x >= (new_position.x - 50) + dx*(f*move_case)  and global_position.x <= (new_position.x + 50) + dx*(f*move_case) \
		and global_position.y >= (new_position.y - 50) + dy*(f*move_case) and global_position.y <= (new_position.y + 50) + dy*(f*move_case):
			self.position = Vector2((new_position.x + dx*(f*move_case)), (new_position.y + dy*(f*move_case)))
			new_position = Vector2(self.position.x, self.position.y)
			chessBoard[i][j] = "0"
			i=i+(dy*f)
			j=j+(dx*f)
			chessBoard[i][j] = "bishop_white"
			break

