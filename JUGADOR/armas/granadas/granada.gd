extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var v = Vector3(0,2,0)
var t = 0
var init = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if(init):
		init = false
	translate(v*delta)
	t += delta
	print(v*delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
