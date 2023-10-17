extends Sprite2D

var dragging = false
var click_radius = 100
var drag_offset = Vector2()
var new_position = Vector2(50, 750)
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
var j = 2

func _ready():
	pass

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
			for f in range (0,8):
				if global_position.x >= f*move_case and global_position.x <= (f*move_case)+move_case \
				and global_position.y >= new_position.y - 50 and global_position.y <= new_position.y + 50:
					self.position = Vector2((f*move_case) + 50, new_position.y)
					new_position = Vector2(self.position.x, self.position.y)
					chessBoard[i][j] = "0"
					j=f+2
					chessBoard[i][j] = "rook_white"
					break
				elif global_position.x >= new_position.x - 50 and global_position.x <= new_position.x + 50 \
				and global_position.y >= f*move_case and global_position.y <= (f*move_case)+move_case:
					self.position = Vector2(new_position.x, (f*move_case) + 50)
					new_position = Vector2(self.position.x, self.position.y)
					chessBoard[i][j] = "0"
					i=f+2
					chessBoard[i][j] = "rook_white"
					break
			self.position = Vector2(new_position.x, new_position.y)
			dragging = false
#			chessBoard[i][j] = 
		for f in range(0,12):
			print(chessBoard[f])
		

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position
