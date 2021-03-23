extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var vida = 500
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_node("Player")
	print(player.name)

func _damaged(var damage):
	vida -= damage
	if(vida <= 0):
		queue_free()
func _process(delta):
	add_central_force(player.translation - translation)
#	pass
