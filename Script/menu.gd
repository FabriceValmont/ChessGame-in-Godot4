extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scene/gameScreen.tscn")
	VariableGlobal.gameLaunch = true


func _on_editor_mod_pressed():
	get_tree().change_scene_to_file("res://Scene/editorMod.tscn")
	VariableGlobalOption.modeEditor = true


func _on_check_button_pressed():
	if get_node("Round").button_pressed ==  false:
		VariableGlobalOption.roundOfThree = false
	elif get_node("Round").button_pressed ==  true:
		VariableGlobalOption.roundOfThree = true


func _on_start_color_pressed():
	if get_node("StartColor").button_pressed == false:
		VariableGlobal.startWhite = true
	elif get_node("StartColor").button_pressed ==  true:
		VariableGlobal.startWhite = false
