extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var hp: int = 1

@onready var anim: AnimatedSprite2D = $PlayerAnim
@onready var playerSprite: Sprite2D = $Player
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		anim.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_update_animation()

func _update_animation() -> void:
	if not is_on_floor():
		playerSprite.hide()
		anim.play("jump")
	elif velocity.x != 0:
		playerSprite.hide()
		anim.play("walk")
	else:
		anim.play("idle")

func _process(delta: float) -> void:
	if hp <= 0:
		queue_free()

func hit() -> void:
	hp -= 1
	print("Player hit!")
