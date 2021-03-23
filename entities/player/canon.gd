extends Spatial

var bala = preload("res://entities/player/bala.res")
export (int) var velocidadDisparo = 300

var canPium = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	while(Input.is_action_pressed("click")) and canPium:
		disparar(velocidadDisparo) # velocidad balas
		$AnimationPlayer.play("pium")
		canPium = false
		$limiteDisparo.start()
	
func disparar(v):
	var nodo_bala = bala.instance()
	
	nodo_bala.translation = global_transform.origin
	var sal = get_node("salida")
	
	get_parent().get_parent().get_parent().get_parent().add_child(nodo_bala)
	
	var dir = global_transform.origin-sal.global_transform.origin
	nodo_bala.v = dir * v

func _on_limiteDisparo_timeout():
	canPium = true
