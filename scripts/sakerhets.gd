extends Area

signal cerillaCollected

var constantes = preload("res://utils/constants.gd")

func _on_sakerhets_body_entered(body) -> void:
	var contador = get_parent().get_parent().get_node("HUD/CERILLAS").cerillasContador
	if body.name == 'Player' and contador <= constantes.cerillasTope:# and contador.cerillas_counter < compare.cerillasTope:
		$lightCollected.start()
		$sakerhets/AnimationPlayer.play("sakerhets_free")
		emit_signal("cerillaCollected")
	else:
		pass

func _on_lightCollected_timeout():
	queue_free()
