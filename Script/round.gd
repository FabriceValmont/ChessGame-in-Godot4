extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		get_node("ScoreRoundWhite").set_text(str(VariableGlobalOption.scoreWhite))
		get_node("ScoreRoundBlack").set_text(str(VariableGlobalOption.scoreBlack))
		if VariableGlobal.checkmate == true and VariableGlobalOption.roundOfThree == true :
			if VariableGlobalOption.scoreWhite < 2 or VariableGlobalOption.scoreBlack < 2:
				if VariableGlobal.checkmateBlack == true :
					VariableGlobalOption.scoreWhite += 1
					VariableGlobal.checkmate = false
					VariableGlobal.checkmateBlack = false
					get_tree().change_scene_to_file("res://Scene/gameScreen.tscn")
				elif VariableGlobal.checkmateWhite == true :
					VariableGlobalOption.scoreBlack += 1
					VariableGlobal.checkmate = false
					VariableGlobal.checkmateWhite = false
					get_tree().change_scene_to_file("res://Scene/gameScreen.tscn")
		if VariableGlobalOption.scoreWhite == 2 or VariableGlobalOption.scoreBlack == 2 :
			VariableGlobalOption.scoreWhite = 0
			VariableGlobalOption.scoreBlack = 0
			VariableGlobal.gameLaunch = false
			get_tree().change_scene_to_file("res://Scene/menu.tscn")
