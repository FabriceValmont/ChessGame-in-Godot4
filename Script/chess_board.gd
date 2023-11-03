extends Sprite2D

var KnightWhite
var KnightBlack

func _ready():
	await get_tree().process_frame
	KnightWhite = get_node("KnightWhite")
	KnightBlack = get_node("KnightBlack")

func _process(delta):
	pass

func blockMoveDuringPromotion(promoteInProgress):
	var numberOfChildren = get_child_count()
	
	for f in range(numberOfChildren):
		var pieceName = get_child(f)
		
		if pieceName.has_method("get_promoteInProgress"):
			# Le nœud a une méthode pour récupérer promoteInProgress
			var promoteInProgressValue = pieceName.get_promoteInProgress()
			
			if promoteInProgressValue != null:
				print("Variable existe dans: ", pieceName.get_name())
				pieceName.promoteInProgress = promoteInProgress
				
				print("pieceName.promoteInProgress: ", pieceName.promoteInProgress)
			else:
				print("Variable est nulle dans: ", pieceName.get_name())
		else:
			print("La méthode get_promoteInProgress n'existe pas dans: ", pieceName.get_name())

func _on_pawn_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_2_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_2_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_3_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_3_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_4_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_4_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_5_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_5_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_6_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_6_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_7_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_7_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)

func _on_pawn_8_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_8_promotion_turn")
	blockMoveDuringPromotion(promoteInProgress)
