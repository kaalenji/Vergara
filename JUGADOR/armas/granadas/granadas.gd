extends Spatial

var granada = preload("res://JUGADOR/armas/granadas/granada.res")
export (int) var granada_speed = 500
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta: float):# -> void:
	if Input.is_action_just_pressed("flare"):
		lanzar_granada()
		

func lanzar_granada():
	var nodo_granada = granada.instance()
	var sal = get_node("salida")
	get_parent().get_parent().add_child(nodo_granada)
	var dir = global_transform.origin-sal.global_transform.origin
	nodo_granada.v = dir * granada_speed
	print(dir)
