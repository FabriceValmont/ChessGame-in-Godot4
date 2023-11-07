extends Node2D

var pathTextTimerWhite
var pathTextTimerBlack 
var timerWhiteSecondes = 600
var timerWhiteMinutes = int(timerWhiteSecondes / 60)
var whiteSecondsRemaining = timerWhiteSecondes % 60
var timerBlackSecondes = 600
var timerBlackMinutes = int(timerBlackSecondes / 60)
var blackSecondsRemaining = timerBlackSecondes % 60

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	pathTextTimerWhite = "TextTimerWhite"
	pathTextTimerBlack = "TextTimerBlack"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timer(_delta)

func timer(_delta):
	if get_node(pathTextTimerWhite) != null and get_node(pathTextTimerBlack) != null:
		get_node(pathTextTimerWhite).set_text("Timer: " + str("%02d:%02d" % [timerWhiteMinutes, whiteSecondsRemaining]))
		get_node(pathTextTimerBlack).set_text("Timer: " + str("%02d:%02d" % [timerBlackMinutes, blackSecondsRemaining]))
		if VariableGlobal.turnWhite == true :
			whiteSecondsRemaining -= _delta #Décompte des secondes
			if whiteSecondsRemaining < 0 : #Si les secondes atteignent 0
				if timerWhiteMinutes > 0 : #Si des minutes restantes
					timerWhiteMinutes -= 1 #Décrémentation des minutes
					whiteSecondsRemaining = 59 #Réinitialisation des secondes
				else :
					whiteSecondsRemaining = 0 #Le timer est terminé
					VariableGlobal.checkmateWhite = true
					VariableGlobal.checkmate = true
					if VariableGlobalOption.roundOfThree == true:
						VariableGlobal.turnWhite = true
						VariableGlobal.updateOfThePartsAttack = false
						VariableGlobal.pieceProtectTheKing = false
						VariableGlobal.initialisingChessBoard()
						VariableGlobal.initialisingAttackBoardWhiteAndBlack()
		elif VariableGlobal.turnWhite == false :
			blackSecondsRemaining -= _delta #Décompte des secondes
			if blackSecondsRemaining < 0 : #Si les secondes atteignent 0
				if timerBlackMinutes > 0 : #Si des minutes restantes
					timerBlackMinutes -= 1 #Décrémentation des minutes
					blackSecondsRemaining = 59 #Réinitialisation des secondes
				else :
					blackSecondsRemaining = 0 #Le timer est terminé
					VariableGlobal.checkmateBlack = true
					VariableGlobal.checkmate = true
					if VariableGlobalOption.roundOfThree == true:
						VariableGlobal.turnWhite = true
						VariableGlobal.updateOfThePartsAttack = false
						VariableGlobal.pieceProtectTheKing = false
						VariableGlobal.initialisingChessBoard()
						VariableGlobal.initialisingAttackBoardWhiteAndBlack()
