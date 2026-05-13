extends Node2D
@onready var anim: AnimatedSprite2D = $DeathScreenAnimation
func start():
	anim.visible = true
	anim.play()
