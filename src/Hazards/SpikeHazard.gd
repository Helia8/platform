extends Node2D


func _on_spike_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):	
		print("Body hit spike, name : ", body.name)
		body.hit()
	pass # Replace with function body.
