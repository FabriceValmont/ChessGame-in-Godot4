extends Node

var pathTextTimerWhite
#@onready var pathTextTimerBlack = $gameScreen/Timer/TextTimerBlack
var timerWhiteSecondes = 600
var timerWhiteMinutes = int(timerWhiteSecondes / 60)
var WhiteSecondsRemaining = timerWhiteSecondes % 60
var timerBlackSecondes = 600
var timerBlackMinutes = int(timerBlackSecondes / 60)
var BlackSecondsRemaining = timerBlackSecondes % 60

# Called when the node enters the scene tree for the first time.
func _ready():
	pathTextTimerWhite = "/root/gameScreen/Timer/TextTimerWhite"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if get_node(pathTextTimerWhite) != null :
		print("TEST")
		get_node(pathTextTimerWhite).set_text("Timer: " + str("%02d:%02d" % [timerWhiteMinutes, WhiteSecondsRemaining]))
#		pathTextTimerBlack.set_text("Timer: " + str("%02d:%02d" % [timerBlackMinutes, BlackSecondsRemaining]))
		if VariableGlobal.turnWhite == true :
			WhiteSecondsRemaining -= _delta #Décompte des secondes
			if WhiteSecondsRemaining < 0 : #Si les secondes atteignent 0
				if timerWhiteMinutes > 0 : #Si des minutes restantes
					timerWhiteMinutes -= 1 #Décrémentation des minutes
					WhiteSecondsRemaining = 59 #Réinitialisation des secondes
				else :
					WhiteSecondsRemaining = 0 #Le timer est terminé
					VariableGlobal.checkmate == true
