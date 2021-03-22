extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var v = Vector3(0,2,0)
var init = true
var t = 0
var ttl = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(init):
		init = false
	translate(v*delta)
	t += delta
	
	if(t >= ttl || global_transform.origin.distance_to(Vector3(0,0,0)) > 50):
		queue_free()
	#print(translation)    
