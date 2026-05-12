extends Node2D

func _on_void_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):	
		print("Body entered the void area: ", body.name)
		body.hit()
	pass # Replace with function body.
