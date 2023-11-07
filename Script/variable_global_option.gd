extends Node

var roundOfThree = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if VariableGlobal.gameLaunch == true:
		if VariableGlobal.checkmate == true and roundOfThree == true :
			VariableGlobal.checkmate = false
			VariableGlobal.checkmateWhite = false
			VariableGlobal.checkmateBlack = false
			get_tree().change_scene_to_file("res://Scene/gameScreen.tscn")
			
			
		
						

