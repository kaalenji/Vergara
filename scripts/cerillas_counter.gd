extends Label

var cerillas_counter = 0

func _ready():
	text = "Cerillas: " + String(cerillas_counter)

func _on_sakerhets_cerillaCollected():
	if cerillas_counter <= 2:
		cerillas_counter += 1
		_ready()
	else:
		pass


func _on_Player_cerillaUsed():
	cerillas_counter -= 1
	#print("cerillas_counter -1")
	_ready()
