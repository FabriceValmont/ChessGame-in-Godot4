extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_menu_button_pressed():
	get_node("Resume").visible = true
	get_node("Abandon").visible = true
	VariableGlobalOption.OpenMenu = true
	VariableGlobal.checkmate = true
	
func _on_resume_pressed():
	get_node("Resume").visible = false
	get_node("Abandon").visible = false
	VariableGlobalOption.OpenMenu = false
	VariableGlobal.checkmate = false


func _on_abandon_pressed():
	VariableGlobal.gameLaunch = false
	VariableGlobal.initialisationDone = false
	VariableGlobal.startWhite = true
	VariableGlobal.turnWhite = true
	VariableGlobal.updateOfThePartsAttack = false
	VariableGlobal.pieceProtectTheKing = false
	VariableGlobal.checkmate = false
	VariableGlobalOption.scoreWhite = 0
	VariableGlobalOption.scoreBlack = 0
	VariableGlobalOption.OpenMenu = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
	
