extends Spatial

var bala = preload("../assets/bala.res")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed("click")):
		disparar(120) # velocidad balas

func disparar(v):
	var nodo_bala = bala.instance()
	
	nodo_bala.translation = global_transform.origin
	var sal = get_node("salida")
	
	get_parent().get_parent().get_parent().get_parent().add_child(nodo_bala)
	
	var dir = global_transform.origin-sal.global_transform.origin
	nodo_bala.v = dir * v
