extends Sprite2D

var KnightWhite
var KnightBlack

func _ready():
	await get_tree().process_frame
	KnightWhite = get_node("KnightWhite")
	KnightBlack = get_node("KnightBlack")

func _process(delta):
	pass

func _on_pawn_3_promotion_turn(promoteInProgress):
	print("Enter _on_pawn_3_promotion_turn")
	if KnightWhite != null:
		KnightWhite.promoteInProgress = promoteInProgress
	if KnightBlack != null:
		KnightBlack.promoteInProgress = promoteInProgress
