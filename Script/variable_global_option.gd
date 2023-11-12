extends Node

var modeEditor = false
var modeDelete = false
var pieceTaken = false
var roundOfThree = false
var scoreWhite = 0
var scoreBlack = 0
var OpenMenu = false
var piecesBlack = [["Pawn", 150, ""],["Pawn", 200,"2"],["Pawn", 250,"3"],["Pawn", 300,"4"],
	["Pawn", 350,"5"],["Pawn", 400,"6"],["Pawn", 450,"7"],["Pawn", 500,"8"],
	["Knight", 550,""],["Knight", 600,"2"],["Bishop", 650,""],["Bishop", 700,"2"],
	["Rook", 750,""],["Rook", 800,"2"],["Queen", 850,""]
]
var piecesWhite = [["Pawn", 850, ""],["Pawn", 800,"2"],["Pawn", 750,"3"],["Pawn", 700,"4"],
	["Pawn", 650,"5"],["Pawn", 600,"6"],["Pawn", 550,"7"],["Pawn", 500,"8"],
	["Knight", 450,""],["Knight", 400,"2"],["Bishop", 350,""],["Bishop", 300,"2"],
	["Rook", 250,""],["Rook", 200,"2"],["Queen", 150,""]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if VariableGlobal.gameLaunch == true and pieceTaken == true:
		for piece_data in piecesBlack:
			var piece_type = piece_data[0]  # Type de la pièce (Pawn, Knight, Bishop, Rook, Queen)
			var position_y = piece_data[1]  # Position y du sprite
			var number = piece_data[2]
		
			# Vérifier si le nœud n'existe pas déjà
			if get_node("/root/gameScreen/ChessBoard/" + piece_type + "Black" + number) == null:
			# Créer un nouveau sprite
				var deadSprite = Sprite2D.new()
				deadSprite.texture = load("res://Sprite/Piece/Black/" + piece_type.to_lower() + "_black.png")
				deadSprite.centered = true
				deadSprite.position.x = 50
				deadSprite.position.y = position_y
				deadSprite.scale.x = 0.5
				deadSprite.scale.y = 0.5
				
				# Ajouter le sprite comme enfant du nœud gameScreen
				get_node("/root/gameScreen").add_child(deadSprite)
				pieceTaken = false
				break
				
		for piece_data in piecesWhite:
			var piece_type = piece_data[0]  # Type de la pièce (Pawn, Knight, Bishop, Rook, Queen)
			var position_y = piece_data[1]  # Position y du sprite
			var number = piece_data[2]
		
			# Vérifier si le nœud n'existe pas déjà
			if get_node("/root/gameScreen/ChessBoard/" + piece_type + "White" + number) == null:
			# Créer un nouveau sprite
				var deadSprite = Sprite2D.new()
				deadSprite.texture = load("res://Sprite/Piece/White/" + piece_type.to_lower() + "_white.png")
				deadSprite.centered = true
				deadSprite.position.x = 950
				deadSprite.position.y = position_y
				deadSprite.scale.x = 0.5
				deadSprite.scale.y = 0.5
				
				# Ajouter le sprite comme enfant du nœud gameScreen
				get_node("/root/gameScreen").add_child(deadSprite)
				pieceTaken = false
				break

