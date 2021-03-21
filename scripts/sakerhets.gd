extends Area

signal cerillaCollected

func _on_sakerhets_body_entered(body):
	if body.name == 'Player':
		$lightCollected.start()
		$sakerhets/AnimationPlayer.play("sakerhets_free")
		emit_signal("cerillaCollected")
	else:
		pass

func _on_lightCollected_timeout():
	queue_free()
