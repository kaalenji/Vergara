extends Spatial

var bala = preload("res://JUGADOR/armas/escopeta/perdigon.res")
export (int) var balaSpeed = 300
export(bool) var espocetaSwitch = false

var timerPium = true
var canPium = true
var numProjectil = 12
var rot = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rot.x = get_parent().rotation.x
	rot.y = get_parent().get_parent().rotation.y
	
	while(Input.is_action_pressed("click")) and timerPium and !get_node("../../").sprinting:
		dispararEscopeta(balaSpeed) # velocidad balas
		espocetaSwitch = !espocetaSwitch
		#if (espocetaSwitch):
		#	get_node("escopeta/AnimationPlayer").play("FireWBullet001")
		#else:
		#	get_node("escopeta2/AnimationPlayer").play("FireWBullet001")
		timerPium = false
		$limiteDisparo.start()
	
func disparar(v):
	var nodo_bala = bala.instance()
	
	nodo_bala.translation = global_transform.origin
	var sal = get_node("salida")
	
	get_parent().get_parent().get_parent().get_parent().add_child(nodo_bala)
	
	var dir = global_transform.origin-sal.global_transform.origin
	nodo_bala.v = dir * v
	
func dispararEscopeta(v):
	for i in range(numProjectil):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var my_random_number1 = rng.randf_range(0, i)
		var my_random_number2 = rng.randf_range(0, i)
		var nodo_bala = bala.instance()
		nodo_bala.translation = global_transform.origin
		var sal = get_node("salida")
		var desv = 0.005*Vector3(cos((float(my_random_number1)/float(numProjectil))*2*PI),sin((float(my_random_number2)/float(numProjectil))*2*PI),sin((float(my_random_number1)/float(numProjectil))*2*PI))
		get_parent().get_parent().get_parent().get_parent().add_child(nodo_bala)
		var dir = global_transform.origin + desv - sal.global_transform.origin
		nodo_bala.v = dir * v
		
func _on_limiteDisparo_timeout():
	timerPium = true
