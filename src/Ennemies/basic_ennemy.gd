extends Node2D


func _on_ennemy_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		print("player hit ennemy")
		body.hit()
	pass # Replace with function body.
