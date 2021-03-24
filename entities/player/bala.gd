extends Area

var v = Vector3(0,2,0)
var init = true
var t = 0
var ttl = 4
export (int) var damage = 50

func _ready():
	pass

func _process(delta):
	if(init):
		init = false
	translate(v*delta)
	t += delta
	
	if(t >= ttl || global_transform.origin.distance_to(Vector3(0,0,0)) > 300):
		queue_free()

func _on_bala_body_entered(_body: PhysicsBody) -> void:
	var target = _body
	print(target.name)
	match(target.get_parent().name):
		"demonios":
			target._damaged(damage)
			queue_free()
		_:
			if target.name != "Player":
				queue_free()
