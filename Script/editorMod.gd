extends Node2D

var white = true
var pieceSelect = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var mousePosition = get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		pieceSelect = ""
		print("pieceSelect: ",pieceSelect)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		selectPiece(mousePosition)

func selectPiece(mousePosition):
	var piece = ["Pawn", "Knight", "Bishop", "Rook", "Queen", "King"]
	for f in range(6):
		if mousePosition.x >= 0 and mousePosition.x <= 100 \
		and mousePosition.y >= 200 + f * 100 and mousePosition.y <= 300 + f * 100:
			pieceSelect = piece[f]
			print("pieceSelect: ", pieceSelect)
			break

func _on_button_pressed():
	white = !white
	if white == true:
		get_node("EditorPawn").texture = preload("res://Sprite/Piece/White/pawn_white.png")
		get_node("EditorKnight").texture = preload("res://Sprite/Piece/White/knight_white.png")
		get_node("EditorBishop").texture = preload("res://Sprite/Piece/White/bishop_white.png")
		get_node("EditorRook").texture = preload("res://Sprite/Piece/White/rook_white.png")
		get_node("EditorQueen").texture = preload("res://Sprite/Piece/White/queen_white.png")
		get_node("EditorKing").texture = preload("res://Sprite/Piece/White/king_white.png")
	elif white == false:
		get_node("EditorPawn").texture = preload("res://Sprite/Piece/Black/pawn_black.png")
		get_node("EditorKnight").texture = preload("res://Sprite/Piece/Black/knight_black.png")
		get_node("EditorBishop").texture = preload("res://Sprite/Piece/Black/bishop_black.png")
		get_node("EditorRook").texture = preload("res://Sprite/Piece/Black/rook_black.png")
		get_node("EditorQueen").texture = preload("res://Sprite/Piece/Black/queen_black.png")
		get_node("EditorKing").texture = preload("res://Sprite/Piece/Black/king_black.png")
