extends Area

func _on_body_entered(body: PhysicsBody) -> void:
	body.flying = true

func _on_body_exited(body: PhysicsBody) -> void:
	body.flying = false
