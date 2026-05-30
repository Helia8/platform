extends CharacterBody2D

const SPEED = 1100.0
const JUMP_VELOCITY = -950.0
@export var DASH_SPEED_MULTIPLIER = 1.5
@export var hp: int = 1
@export var dash_duration: float = 0.10
@export var dash_length: float = 1.0
@export var jump_hold_duration: float = 0.24
@export var jump_hold_gravity_multiplier: float = 0.65
@export var max_fall_speed: float = 1800.0
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
var air_dash_used: bool = false

func _apply_vertical_movement(delta: float) -> void:
	if is_on_floor() and velocity.y >= 0.0:
		return

	var gravity_multiplier := 2.0 if velocity.y < 0.0 else 4.0
	var gravity := get_gravity().y * gravity_multiplier
	if velocity.y < 0.0 and Input.is_action_pressed("jump") and jump_hold_time_left > 0.0:
		gravity *= jump_hold_gravity_multiplier
		jump_hold_time_left -= delta
	else:
		jump_hold_time_left = 0.0

	velocity.y = min(velocity.y + gravity * delta, max_fall_speed)

func _physics_process(delta: float) -> void:
	if not running:
		return
	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0.0:
			is_dashing = false
			dash_time_left = 0.0
			velocity = dash_velocity * 0.5
			dash_velocity = Vector2.ZERO
			dash_input_velocity = Vector2.ZERO
	if is_dashing:
		velocity = dash_velocity
		move_and_slide()
		if is_on_floor():
			air_dash_used = false
		platVel = get_platform_velocity()
		_update_animation()
		return

	_apply_vertical_movement(delta)

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
				velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * 3.5 * delta)
			anim.flip_h = direction > 0
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * 3.5 * delta)

	if Input.is_action_just_pressed("dash") and (is_on_floor() or not air_dash_used):
		var dash_direction := Input.get_vector("left", "right", "up", "down")
		if dash_direction == Vector2.ZERO:
			dash_direction.x = 1.0 if anim.flip_h else -1.0
		dash_direction = dash_direction.normalized()
		is_dashing = true
		dash_time_left = dash_duration
		dash_velocity = dash_direction * dash_length * SPEED * DASH_SPEED_MULTIPLIER
		dash_input_velocity = Vector2.ZERO
		velocity = dash_velocity
		if not is_on_floor():
			air_dash_used = true
	elif is_dashing:
		velocity = dash_velocity
	else:
		dash_input_velocity = Vector2.ZERO
	move_and_slide()
	if is_on_floor():
		air_dash_used = false
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
