extends RigidBody

var player

func _ready():
	player = get_parent().get_node("Player")
	print(player.name)

func _process(_delta):
	add_central_force(player.translation - translation)
	pass
