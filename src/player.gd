extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -700.0
const FALL_GRAVITY = 1000.0
const JUMP_GRAVITY = -700.0
@export var hp: int = 1
@export var dash_duration: float = 0.2
@export var dash_length: float = 2.0
@export var jump_hold_duration: float = 0.30
@export var jump_hold_gravity_multiplier: float = 0.75
@onready var winScreen: Node2D = $WinScreen
@onready var deathScreen: Node2D = $DeathScreen
@onready var anim: AnimatedSprite2D = $PlayerAnim
@onready var playerSprite: Sprite2D = $Player
var iseconds: float = 0
var running = true
var platVel: Vector2 = Vector2.ZERO
var bounce = false
var is_dashing = false
var dash_time_left: float = 0.0
var dash_velocity: Vector2 = Vector2.ZERO
var dash_input_velocity: Vector2 = Vector2.ZERO
var jump_hold_time_left: float = 0.0
func _physics_process(delta: float) -> void:
	if not running:
		return
	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0.0:
			is_dashing = false
			dash_time_left = 0.0
			dash_velocity = Vector2.ZERO
			dash_input_velocity = Vector2.ZERO
	if not is_on_floor():
		#velocity.y += FALL_GRAVITY * delta
		if velocity.y < 0 and Input.is_action_pressed("jump") and jump_hold_time_left > 0.0:
			velocity += get_gravity() * jump_hold_gravity_multiplier * delta
			jump_hold_time_left -= delta
		else:
			if velocity.y < 0:
				velocity += get_gravity() * 2.5 * delta
			else:
				velocity += get_gravity() * 3.5 * delta

	if (Input.is_action_just_pressed("jump") and is_on_floor()) or bounce:
		velocity.y = JUMP_VELOCITY
		velocity.x = platVel.x
		jump_hold_time_left = jump_hold_duration
		bounce = false
	elif Input.is_action_just_released("jump"):
		jump_hold_time_left = 0.0

	var direction := Input.get_axis("left", "right")
	if not is_dashing:
		if direction:
			if is_on_floor():
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * delta)
			anim.flip_h = direction > 0
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	if (Input.is_action_just_pressed("dash")):
		var dash_direction := Input.get_vector("left", "right", "up", "down")
		if dash_direction == Vector2.ZERO:
			dash_direction.x = 1.0 if anim.flip_h else -1.0
		dash_direction = dash_direction.normalized()
		is_dashing = true
		dash_time_left = dash_duration
		dash_velocity = dash_direction * dash_length * SPEED
		dash_input_velocity = Vector2.ZERO
		velocity = dash_velocity
	elif is_dashing:
		var dash_control_input := Input.get_vector("left", "right", "up", "down")
		dash_input_velocity = dash_input_velocity.move_toward(dash_control_input * SPEED * 0.5, SPEED * 3.0 * delta)
		velocity = dash_velocity + dash_input_velocity
	else:
		dash_input_velocity = Vector2.ZERO
	move_and_slide()
	platVel = get_platform_velocity()
	_update_animation()

func _update_animation() -> void:
	if not is_on_floor():
		playerSprite.hide()
		if (velocity.y < 0):
			anim.play("jump_rising")
		else:
			anim.play("jump_falling")
	elif velocity.x != 0:
		playerSprite.hide()
		anim.play("walk")
	else:
		anim.play("idle")

func _process(delta: float) -> void:
	if iseconds > 0:
		iseconds -= delta
	else:
		iseconds = 0
	if not running:
		return
	if hp <= 0:
		running = false
		return
		queue_free()

func hit() -> void:
	if (iseconds > 0):
		return
	hp -= 1
	print("Player hit!")
	if (hp <= 0):
		deathScreen.visible = true
		deathScreen.start()
		

func win() -> void:
	running = false
	winScreen.visible = true
	winScreen.start()
	
func pickup_coin():
	print("picked up coin")

func make_bounce():
	bounce = true
func add_iseconds(nb :float):
	iseconds += nb;
