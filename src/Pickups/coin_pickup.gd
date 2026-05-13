extends Node2D

@onready var anim: AnimatedSprite2D = $CoinAnim

func _on_coin_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.pickup_coin()
		#anim.visible = false
		queue_free()
	pass # Replace with function body.
