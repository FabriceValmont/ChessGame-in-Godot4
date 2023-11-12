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
		if pieceSelect != "":
			pieceSelect = ""
			print("pieceSelect: ",pieceSelect)
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		selectPiece(mousePosition)
		insertPiece(mousePosition)

func selectPiece(mousePosition):
	var pieces = ["Pawn", "Knight", "Bishop", "Rook", "Queen", "King"]
	for f in range(6):
		if mousePosition.x >= 0 and mousePosition.x <= 100 \
		and mousePosition.y >= 200 + f * 100 and mousePosition.y <= 300 + f * 100:
			pieceSelect = pieces[f]
			print("pieceSelect: ", pieceSelect)
			break

func insertPiece(mousePosition):
	print("Enter in insertPieceSelectPosition")
	var pieces = ["Pawn", "Knight", "Bishop", "Rook", "Queen", "King"]
	for i in range(10): 
		for j in range(10):
			if mousePosition.x >= 100 + i * 100 and mousePosition.x <= 200 + i * 100\
			and mousePosition.y >= 100 + j * 100 and mousePosition.y <= 200 + j * 100:
				for piece in pieces:
					if pieceSelect == piece and white == true:
						var sceneInstance = load("res://Scene/"+piece.to_lower()+".tscn").instantiate()
						sceneInstance.white = true
						sceneInstance.position.x = i * 100 + 50
						sceneInstance.position.y = j * 100 + 50
						get_node("ChessBoard").add_child(sceneInstance)
					elif pieceSelect == piece and white == false:
						var sceneInstance = load("res://Scene/"+piece.to_lower()+".tscn").instantiate()
						sceneInstance.white = false
						sceneInstance.position.x = i * 100 + 50
						sceneInstance.position.y = j * 100 + 50
						get_node("ChessBoard").add_child(sceneInstance)

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

func _on_delete_all_piece_pressed():
	var numberOfChildren = get_node("ChessBoard").get_child_count()
	for f in range(numberOfChildren):
		var piece = get_node("ChessBoard").get_child(f)
		piece.queue_free()
	for i in range(2,10):
		for j in range(2,10):
			VariableGlobal.chessBoard[i][j] = null
	for f in range(0,12):
		print(VariableGlobal.chessBoard[f])

func _on_mode_delete_pressed():
	if VariableGlobalOption.modeDelete == false:
		get_node("ModeDelete").set_text("Delete: \nEnabled")
		VariableGlobalOption.modeDelete = true
	elif VariableGlobalOption.modeDelete == true:
		get_node("ModeDelete").set_text("Delete: \nDisabled")
		VariableGlobalOption.modeDelete = false

func _on_quit_pressed():
	pieceSelect = ""
	VariableGlobalOption.modeEditor = true
	VariableGlobalOption.modeDelete = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")

func _on_play_pressed():
	var movePreviewNode = Node2D.new()
	movePreviewNode.name = "MovePreview"
	for f in range(11):
		get_child(f).queue_free()
	add_child(load("res://Scene/gameMenu.tscn").instantiate())
	add_child(load("res://Scene/displayCheckmate.tscn").instantiate())
	add_child(movePreviewNode)
	set_name("gameScreen")
	set_script(null)
	VariableGlobal.gameLaunch = true
	
