extends Label

var cerillasContador = 0

func _ready():
	text = "Cerillas: " + String(cerillasContador)

func _on_sakerhets_cerillaCollected():
	cerillasContador += 1
	_ready()


func _on_Player_cerillaUsed():
	cerillasContador -= 1
	_ready()
