extends Area

var v = Vector3(0,2,0)
var init = true
var t = 0
var ttl = 4

func _ready():
	pass

func _process(delta):
	if(init):
		init = false
	translate(v*delta)
	t += delta
	
	if(t >= ttl || global_transform.origin.distance_to(Vector3(0,0,0)) > 50):
		queue_free()

func _on_bala_body_entered(_body: PhysicsBody) -> void:
	$AnimationPlayer.play("bala_free")
	$balaColision.start()

func _on_balaColision_timeout():
	queue_free()
