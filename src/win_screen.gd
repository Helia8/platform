extends Node2D

@onready var anim: AnimatedSprite2D = $WinScreenAnimation
func start():
	anim.visible = true
	anim.play("default")

func _process(delta: float):
	if (!anim.is_playing() and anim.visible):
		anim.play("idle")
