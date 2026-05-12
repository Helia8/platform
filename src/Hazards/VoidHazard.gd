extends Node2D

func _on_void_area_body_entered(body: Node2D) -> void:
	print("Body entered the void area: ", body.name)
	body.hit()
	pass # Replace with function body.
